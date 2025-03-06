require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    # Simulate authentication
    request.headers['Authorization'] = "#{user.authentication_token}"
  end

  describe "POST #borrow" do
    context "when the user has sufficient balance and the book is available" do
      before do
        book.update(fee: 10)
        post :borrow, params: { user_id: user.id, book_id: book.id }
      end

      it "creates a borrow transaction" do
        expect(user.transactions.count).to eq(1)
      end

      it "does not deduct the fee from the user's balance" do
        user.reload
        expect(user.balance.to_i).to eq(100)
      end

      it "decrements the available copies of the book" do
        book.reload
        expect(book.available_copies).to eq(9)
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the transaction details" do
        expect(JSON.parse(response.body)['data']['attributes']['amount']).to eq("-10.0")
      end
    end

    context "when the user has insufficient balance" do
      before do
        user.update(balance: 5) # Set balance below the book fee
        book.update(fee: 10)
        post :borrow, params: { user_id: user.id, book_id: book.id }
      end

      it "does not create a transaction" do
        expect(user.transactions.count).to eq(0)
      end

      it "returns an error message" do
        expect(JSON.parse(response.body)['error']).to eq('Insufficient balance or no available copies')
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the book is not available" do
      before do
        book.update(available_copies: 0) # Set available copies to 0
        post :borrow, params: { user_id: user.id, book_id: book.id }
      end

      it "does not create a transaction" do
        expect(user.transactions.count).to eq(0)
      end

      it "returns an error message" do
        expect(JSON.parse(response.body)['error']).to eq('Insufficient balance or no available copies')
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST #return" do
    let!(:transaction) { create(:transaction, user: user, book: book, amount: -book.fee, returned: false) }

    context "when the user has borrowed the book" do
      before do
        post :return, params: { user_id: user.id, book_id: book.id }
      end

      it "marks the transaction as returned" do
        transaction.reload
        expect(transaction.returned).to be true
      end

      it "increments the available copies of the book" do
        book.reload
        expect(book.available_copies).to eq(11)
      end

      it "returns a success message" do
        expect(JSON.parse(response.body)['message']).to eq('Book was returned successfully.')
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user has not borrowed the book" do
      before do
        transaction.update(returned: true) # Mark the transaction as already returned
        post :return, params: { user_id: user.id, book_id: book.id }
      end

      it "returns an error message" do
        expect(JSON.parse(response.body)['error']).to eq('You have not borrowed this book or have already returned all copies')
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

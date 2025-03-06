require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    # Simulate authentication
    request.headers['Authorization'] = "#{user.authentication_token}"
  end

  describe "GET #account_status" do
    context "when the user has active borrowed books" do
      before do
        create(:transaction, user: user, book: book, transaction_type: 'borrow')
        get :account_status, params: { user_id: user.id }
      end

      it "returns the user's balance" do
        expect(JSON.parse(response.body)['data']['balance']).to eq("#{user.balance.to_f}")
      end

      it "returns the list of borrowed books" do
        expect(JSON.parse(response.body)['data']['borrowed_books']).not_to be_empty
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user has no active borrowed books" do
      before do
        get :account_status, params: { user_id: user.id }
      end

      it "returns an empty list of borrowed books" do
        expect(JSON.parse(response.body)['data']['borrowed_books']['data']).to be_empty
      end
    end
  end

  describe "GET #monthly_report" do
    context "when the user has transactions in the current month" do
      before do
        create(:transaction, user: user, book: book, amount: -10.0, created_at: Time.current)
        get :monthly_report, params: { user_id: user.id }
      end

      it "returns the amount spent" do
        expect(JSON.parse(response.body)['data']['amount_spent']).to eq(10.0)
      end

      it "returns the total books borrowed" do
        expect(JSON.parse(response.body)['data']['books_borrowed']).to eq(1)
      end

      it "returns the unique books borrowed" do
        expect(JSON.parse(response.body)['data']['unique_books_borrowed']).to eq(1)
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user has no transactions in the current month" do
      before do
        get :monthly_report, params: { user_id: user.id }
      end

      it "returns zero for all metrics" do
        data = JSON.parse(response.body)['data']
        expect(data['amount_spent']).to eq(0.0)
        expect(data['books_borrowed']).to eq(0)
        expect(data['unique_books_borrowed']).to eq(0)
      end
    end
  end

  describe "GET #annual_report" do
    context "when the user has transactions in the current year" do
      before do
        create(:transaction, user: user, book: book, amount: -10.0, created_at: Time.current)
        get :annual_report, params: { user_id: user.id }
      end

      it "returns the amount spent" do
        expect(JSON.parse(response.body)['data']['amount_spent']).to eq(10.0)
      end

      it "returns the total books borrowed" do
        expect(JSON.parse(response.body)['data']['books_borrowed']).to eq(1)
      end

      it "returns the unique books borrowed" do
        expect(JSON.parse(response.body)['data']['unique_books_borrowed']).to eq(1)
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user has no transactions in the current year" do
      before do
        get :annual_report, params: { user_id: user.id }
      end

      it "returns zero for all metrics" do
        data = JSON.parse(response.body)['data']
        expect(data['amount_spent']).to eq(0.0)
        expect(data['books_borrowed']).to eq(0)
        expect(data['unique_books_borrowed']).to eq(0)
      end
    end
  end
end

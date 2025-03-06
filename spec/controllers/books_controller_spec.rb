require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe "GET #index" do
    context "when there are books" do
      before do
        create_list(:book, 3)
        get :index
      end

      it "returns a list of books" do
        expect(JSON.parse(response.body).size).to eq(3)
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when there are no books" do
      before do
        get :index
      end

      it "returns an empty list" do
        expect(JSON.parse(response.body)).to be_empty
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #income" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:start_time) { 1.week.ago.iso8601 }
    let(:end_time) { Time.current.iso8601 }

    before do
      request.headers['Authorization'] = "#{user.authentication_token}"
    end

    context "when the book has transactions within the time range" do
      before do
        create(:transaction, book: book, amount: -10.0, created_at: 2.days.ago)
        create(:transaction, book: book, amount: -15.0, created_at: 3.days.ago)
        get :income, params: { id: book.id, user_id: user.id, start_time: start_time, end_time: end_time }
      end

      it "returns the total income" do
        expect(JSON.parse(response.body)['total_income']).to eq("25.0")
      end

      it "returns the book ID" do
        expect(JSON.parse(response.body)['book_id']).to eq(book.id)
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the book has no transactions within the time range" do
      before do
        create(:transaction, book: book, amount: -10.0, created_at: 2.weeks.ago)
        create(:transaction, book: book, amount: -15.0, created_at: 1.month.ago)
        get :income, params: { id: book.id, user_id: user.id, start_time: start_time, end_time: end_time }
      end

      it "returns zero income" do
        expect(JSON.parse(response.body)['total_income']).to eq("0.0")
      end

      it "returns a 200 status code" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the book does not exist" do
      before do
        get :income, params: { id: 'invalid', user_id: user.id, start_time: start_time, end_time: end_time }
      end

      it "returns a 404 status code" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the user is not authenticated" do
      before do
        request.headers['Authorization'] = nil
        get :income, params: { id: book.id, start_time: start_time, end_time: end_time }
      end

      it "returns a 401 status code" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the end time is earlier than the start time" do
      before do
        get :income, params: { id: book.id, user_id: user.id, start_time: Time.current.iso8601, end_time: 1.week.ago.iso8601 }
      end

      it "returns an error message" do
        expect(JSON.parse(response.body)['error']).to eq('End time must be later than start time')
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the start time or end time is missing" do
      before do
        get :income, params: { id: book.id, user_id: user.id, start_time: nil, end_time: Time.current.iso8601 }
      end

      it "returns an error message" do
        expect(JSON.parse(response.body)['error']).to eq('Start time and end time are required')
      end

      it "returns a 422 status code" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

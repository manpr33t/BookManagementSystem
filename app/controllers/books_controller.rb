class BooksController < ApplicationController
	before_action :authenticate_user_from_token!, only: [:income]
	
  def index
    books = Book.all
    render json: books
  end

  def income
    book = Book.find(params[:id])
    start_time = params[:start_time]
    end_time = params[:end_time]
    transactions = book.transactions.where(created_at: start_time..end_time)
    total_income = transactions.sum(:amount)
    render json: { book_id: book.id, total_income: total_income.abs }
  end
end

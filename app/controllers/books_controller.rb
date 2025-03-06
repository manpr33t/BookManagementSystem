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
    
    # Validate the time parameter
    if start_time.blank? || end_time.blank?
      return render json: { error: 'Start time and end time are required' }, status: :unprocessable_entity
    end
    
    if end_time <= start_time
      return render json: { error: 'End time must be later than start time' }, status: :unprocessable_entity
    end

    transactions = book.transactions.where(created_at: start_time..end_time)
    total_income = transactions.sum(:amount)
    render json: { book_id: book.id, total_income: total_income.abs }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end
end

class TransactionsController < ApplicationController

	before_action :authenticate_user!

  def borrow
    user = User.find(params[:user_id])
    book = Book.find(params[:book_id])

    if user.balance >= book.fee && book.available_copies > 0
      transaction = user.transactions.create(
      	book: book,
      	transaction_type: 'borrow',
      	amount: -book.fee
      )
      book.update_inventory(1, true)
      render json: TransactionSerializer.new(transaction).serializable_hash, status: :ok
    else
      render json: { error: 'Insufficient balance or no available copies' }, status: :unprocessable_entity
    end
  end

  def return
    user = User.find(params[:user_id])
    book = Book.find(params[:book_id])
    transaction = user.transactions.create(book: book, transaction_type: 'return', amount: book.fee)
    book.update_inventory(1, false)
    render json: { message: 'Book returned successfully' }, status: :ok
  end
end

class TransactionsController < ApplicationController
  before_action :authenticate_user_from_token!

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
    user = current_user
    book = Book.find(params[:book_id])
    active_transaction = user.transactions.where(book_id: book.id, amount: -book.fee, returned: false).first

    if book && active_transaction
      # Update transaction to return
      active_transaction.mark_as_returned
      # Update the available count
      book.update_inventory(1, false)
      render json: {
        message: 'Book was returned successfully.',
        data: TransactionSerializer.new(active_transaction).serializable_hash[:data] 
      }, status: :ok
    else
      render json: { error: 'You have not borrowed this book or have already returned all copies' }, status: :unprocessable_entity
    end
  end
end

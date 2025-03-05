class UsersController < ApplicationController
	before_action :authenticate_user_from_token!

  def account_status
    user = User.find(params[:user_id])
    render json: {
    	data: {
    		balance: user.balance,
    		borrowed_books: TransactionSerializer.new(
          user.transactions.active_borrowed
        ).serializable_hash
    	}
    }
  end

  def monthly_report
    user = User.find(params[:user_id])
    monthly_transactions = Transaction.for_current_month.where(user_id: user.id)
    render json: {
      data: {
        amount_spent: monthly_transactions.sum(:amount).to_f.abs,
        books_borrowed: monthly_transactions.count,
        unique_books_borrowed: monthly_transactions.select(:book_id).distinct.count
      }
    }
  end

  def annual_report
    user = User.find(params[:user_id])
    yearly_transactions = Transaction.for_current_year.where(user_id: user.id)
    render json: {
      data: {
        amount_spent: yearly_transactions.sum(:amount).to_f.abs,
        books_borrowed: yearly_transactions.count,
        unique_books_borrowed: yearly_transactions.select(:book_id).distinct.count
      }
    }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :account_number, :balance)
  end
end

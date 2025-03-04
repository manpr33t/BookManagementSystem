class UsersController < ApplicationController

	before_action :authenticate_user!, except: [:create]

  def account_status
    user = User.find(params[:id])
    render json: {
    	data: {
    		balance: user.balance,
    		borrowed_books: TransactionSerializer.new(
          user.transactions.borrowed,
          { include: [:book] }
        ).serializable_hash
    	}
    }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :account_number, :balance)
  end
end

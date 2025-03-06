class ApplicationController < ActionController::API
  private

  def authenticate_user_from_token!
    token = request.headers['Authorization']&.split(' ')&.last
    user = token && User.find_by(id: params['user_id'], authentication_token: token)

    if user
      sign_in(user, store: false)
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end

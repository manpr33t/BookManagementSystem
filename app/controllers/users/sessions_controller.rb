class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        data: UserSerializer.new(resource).serializable_hash[:data],
        token: resource.authentication_token
      }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    # Logout successful
    if current_user.present?
      current_user.regenerate_authentication_token
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { message: "User is not logged in" }, status: :unauthorized
    end
  end
end

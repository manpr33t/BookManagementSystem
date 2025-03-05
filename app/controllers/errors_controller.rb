class ErrorsController < ApplicationController

  def route_not_found
    render json: {
      error: "Route not found",
      message: "The requested route '#{request.path}' does not exist.",
      method: request.method
    }, status: :not_found
  end
end

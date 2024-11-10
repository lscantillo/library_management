class Api::V1::ApplicationController < ActionController::API
include Pagy::Backend
  before_action :authenticate

  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  private

  def authenticate
    authorization_header = request.headers["Authorization"]
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JsonWebToken.decode(token)

    User.find(decoded_token[:user_id])
  end

  def current_user
    @current_user ||= authenticate
  end

  def invalid_token
    render json: { invalid_token: "Invalid token" }
  end

  def decode_error
    render json: { decode_error: "Decode error" }
  end

  def authorize_user
    render json: { message: "You don't have permission to do this." }, status: :unauthorized unless current_user&.librarian?
  end
end

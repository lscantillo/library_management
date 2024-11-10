class Api::V1::AuthenticationController < Api::V1::ApplicationController
  skip_before_action :authenticate

  def login
    user = User.find_by(email: params[:email])
    authenticated_user = user&.valid_password?(params[:password])

    if authenticated_user
      token = JsonWebToken.encode(user_id: user.id)
      expires_at = JsonWebToken.decode(token)[:exp]

      render json: { token:, expires_at: }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  def signup
    if User.create!(email: user_params[:email], password: user_params[:password], role: "member")
      render json: { message: "User created", token: JsonWebToken.encode(user_id: User.last.id) }, status: :ok
    else
      render json: { message: "User could not be created" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

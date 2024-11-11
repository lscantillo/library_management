module AuthHelper
  def authenticate_user(custom_user = nil)
    user_to_authenticate = custom_user || user  # Use custom_user if provided, otherwise default to `user`
    post '/api/v1/login', params: { email: user_to_authenticate.email, password: user_to_authenticate.password }
    JSON.parse(response.body)['token']
  end
end

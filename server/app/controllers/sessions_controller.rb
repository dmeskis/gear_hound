class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    authenticate session_params[:email], session_params[:password]
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)
    user = User.where(email: command.email).first
    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful',
        user: {
          id: user.id,
          email: command.email,
          first_name: user.first_name,
          last_name: user.last_name,
          avatar: user.avatar
        }
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
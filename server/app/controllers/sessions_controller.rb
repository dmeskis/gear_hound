class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    authenticate session_params[:username], session_params[:password]
  end

  private

  def authenticate(username, password)
    command = AuthenticateUser.call(username, password)
    user = User.find_for_database_authentication(command.username)
    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful',
        user: {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
        }
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def session_params
    params.require(:session).permit(:username, :password)
  end

end
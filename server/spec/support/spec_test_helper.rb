module SpecTestHelper
  def signin(user)
    session_params = {
      email: user.email,
      password: user.password
    }
    post '/session', params: { session: session_params }
  end

  def signout
    # cookies[:identity] = nil
  end

  # def current_user
  #   User.find(session[:identity])
  # end
end

RSpec.configure do |config|
  config.include SpecTestHelper, type: :request
end
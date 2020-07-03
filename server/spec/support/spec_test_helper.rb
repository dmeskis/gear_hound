module SpecTestHelper
  def signin(user)
    post 
  end

  def signout
    cookies[:identity] = nil
  end

  def current_user
    User.find(session[:identity])
  end
end

RSpec.configure do |config|
  config.include SpecTestHelper, type: :request
end
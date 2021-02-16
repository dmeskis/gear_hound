module SpecTestHelper

  def auth_header(user)
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}"}
  end

end

RSpec.configure do |config|
  config.include SpecTestHelper, type: :request
end
class Api::V1::UsersController < Api::V1::BaseController
  include Crud

  def cache_context_options
    @MODEL = User
    @SERIALIZER = API::V1::UserSerializer
    @PARAMS = [:first_name, :last_name, :email, :password]
    @PERMISSIONS = true
  end

end

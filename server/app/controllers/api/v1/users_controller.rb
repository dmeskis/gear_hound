class Api::V1::UsersController < Api::V1::BaseController
  include Crud

  def cache_context_options
    @MODEL = User
    @SERIALIZER = Api::V1::UserSerializer
    @PARAMS = [:first_name, :last_name, :username, :email, :password]
    @PERMISSIONS = true
  end

  skip_before_action :authenticate_request, only: [:create]
end

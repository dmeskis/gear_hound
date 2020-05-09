class Api::V1::UserSerializer < ActiveModel::Serializer
  include ModelSerializer
  attributes :username, :first_name, :last_name, :email, :phone_number, :date_of_birth
end

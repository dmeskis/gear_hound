require 'rails_helper'
require 'support/spec_test_helper'

RSpec.describe "Users", type: :request do
  before(:all) do
    @user = create(:user)
  end
  describe 'POST #create' do
    it 'creates a user' do
      user = build(:user)
      user_params = user.slice('first_name', 'last_name', 'username', 'email', 'password')
      post '/api/v1/users', params: { user: user_params }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'requires a user to be logged in' do
      get '/api/v1/users/:id', params: { id: @user.id }
      expect(response.status).to eq(401)
    end

    it 'gets a user' do
      signin @user
      get '/api/v1/users/:id', params: { id: @user.id }
      binding.pry
      expect(response).to be_successful
      expect(response.parsed_body['id']).to_equal @user.id
    end
  end
end

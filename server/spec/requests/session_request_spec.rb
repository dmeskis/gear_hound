require 'rails_helper'
require 'support/spec_test_helper'

RSpec.describe "Users", type: :request do
  before(:all) do
    @user = create(:user)
  end

  describe 'POST #create' do
    it 'creates a session' do
      session_params = {
        email: @user.email,
        password: @user.password
      }
      post '/session', params: { session: session_params }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    # it 'user must be logged in' do
    #   get '/api/v1/session', params: { id: @user.id }
    #   expect(response.status).to eq(401)
    # end

    # it 'gets a session' do
    #   # signin @user
    #   get '/session', params: { id: @user.id }
    #   binding.pry
    #   expect(response.status).to eq(200)
    # end
  end

  # describe 'DELETE #destroy' do
  #   it 'destroys a session' do

  #   end
  # end
end

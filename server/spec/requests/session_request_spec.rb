require 'rails_helper'
require 'support/spec_test_helper'

RSpec.describe "Users", type: :request do
  before(:all) do
    @user = create(:user)
  end

  describe 'POST #create' do
    it 'creates a session using email' do
      session_params = {
        username: @user.email,
        password: @user.password
      }
      post '/session', params: { session: session_params }
      expect(response).to be_successful
    end

    it 'creates a session using username' do
      session_params = {
        username: @user.username,
        password: @user.password
      }
      post '/session', params: { session: session_params }
      expect(response).to be_successful
    end
  end
end

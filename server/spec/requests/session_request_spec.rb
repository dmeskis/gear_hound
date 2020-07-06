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
end

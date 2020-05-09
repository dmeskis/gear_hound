require 'test_helper'
class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
  end

  test 'create' do
    user = build(:user)
    user_params = user.slice('first_name', 'last_name', 'username', 'email', 'password')
    post :create, params: { user: user_params }
    assert_response 201
  end

  test 'show' do
    signin @user
    get :show, params: { id: @user.id }
    assert_response 200
    assert_equal @user.id, json['user']['id']
  end

  test 'update' do
    signin @user
    username = Faker::Internet.username
    put :update, params: { id: @user.id, user: { username: username } }
    assert_response 200
    assert_equal username, json['user']['username']
  end

  test 'destroy' do
    signin @user
    delete :destroy, params: { id: @user.id }
    assert_response 204
  end
end

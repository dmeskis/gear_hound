require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test 'invalid without username' do
    @user.username = nil
    refute @user.valid?
  end

  test 'invalid without email' do
    @user.email = nil
    refute @user.valid?
  end
  
  test 'username must be unique' do
    new_user = build(:user, username: @user.username)
    refute new_user.valid?
  end
  
  test 'email must be unique' do
    new_user = build(:user, email: @user.email)
    refute new_user.valid?
  end
end

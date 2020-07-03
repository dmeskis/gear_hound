require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = create(:user)
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'is invalid without username' do
    @user.username = nil
    expect(@user).to_not be_valid
  end

  it 'is invalid without email' do
    @user.email = nil
    expect(@user).to_not be_valid
  end
  
  it 'username must be unique' do
    new_user = build(:user, username: @user.username)
    expect(new_user).to_not be_valid
  end
  
  it 'email must be unique' do
    new_user = build(:user, email: @user.email)
    expect(new_user).to_not be_valid
  end
end

class User < ApplicationRecord
  has_secure_password
  strip_attributes

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.find_for_database_authentication(username)
    find_by(username: username) || find_by(email: username)
  end
end

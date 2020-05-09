ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require 'mocha/minitest'
require "database_cleaner"
require "faker"

module AroundEachTest
  def before_setup
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
end

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  include AroundEachTest
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def signin(user)
    session[:identity] = user.id
  end

  def signout
    session[:identity] = nil
  end

  def json
    ActiveSupport::JSON.decode(response.body)
  end
end

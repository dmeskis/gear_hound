module Auth
  extend ActiveSupport::Concern
  included do
    include ActionController::Cookies
    include ActionController::RequestForgeryProtection
    # include JsonWebToken

    protect_from_forgery with: :exception, unless: -> { running_test_suite }
    before_action :cache_session_user, :require_session, :cache_session

    rescue_from ActiveRecord::RecordNotFound do |e|
      error([:not_found])
    end

    rescue_from ActionController::InvalidAuthenticityToken do |e|
      signout
      error([:invalid_request_token])
    end

    def cache_session_user
      p @current_user
      p session
      @current_user = User.find_by(id: session[:identity]) if session[:identity]
    end

    def require_session
      p @current_user
      return error([:unauthorized_request]) unless @current_user
    end

    def require_admin_session
      return error([:unauthorized_request]) unless @current_user.admin?
    end

    def cache_session
      @current_session = {
        user_id: @current_user.id
      }
    end

    def cache_session_timeout
      if @current_user && @current_group && @current_group.has_session_timeout?
        @session_timeout = SessionTimeout.find_or_create_by(user: @current_user, group: @current_group)
      end
    end

    def progress_timeout_state
      cache_session_timeout
      if @session_timeout
        if @session_timeout.should_remain_active?
          @session_timeout.set_timeout!
        else
          reset_session
          return error([:session_timed_out])
        end
      end
    end

    def signin(user)
      session[:identity] = user.id
    end

    def signout
      reset_session
    end

    private

    def running_test_suite
      ['development', 'test'].include?(ENV['RAILS_ENV'])
    end
  end
end

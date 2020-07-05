class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :cache_session_user, :require_session, :cache_session, only: [:create]

  def show
    render_session 200, @current_user
  end

  def create
    authenticate_response = User.authenticate(session_params)
    return error([authenticate_response]) if authenticate_response.class != User
    @current_user = authenticate_response
    signin @current_user
    cache_session
    reset_session_timeout
    render_session 201, @current_user
  end

  # def update
  #   new_session = update_session_params
  #   if new_session[:group_id]
  #     group = Group.includes([:policies]).find_by(id: new_session[:group_id])
  #     return error([:not_found]) if group.blank?
  #     return error([:group_disabled]) unless group.enabled?
  #     return error([:unauthorized_request]) unless group.is_user_member?(@current_user)
  #     NUserSessionCache.change_group(@current_user, new_session)
  #   end

  #   reset_session_timeout
  #   render_session 200, @current_user
  # end

  def destroy
    signout
    head :no_content
  end

  private
  def session_params
    params.require(:session).permit(:email, :username, :password)
  end

  def update_session_params
    params.require(:session).permit(:group_id)
  end

  def render_session(status, user)
    json = build_session_object(user)
    if json.in?([:standard_auth_disabled, :no_active_group_or_network, :unauthorized_request])
      signout
      return error([json])
    end
    render json: json, status: status
  end

  def build_session_object(user)
    return :unauthorized_request unless user

    session_cache = {
      user_id: user.id
    }

    { session: session_cache }
  end
end

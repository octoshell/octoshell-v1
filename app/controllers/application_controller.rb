# coding: utf-8
class ApplicationController < ActionController::Base
  attr_accessor :skip_authentication_by_token
  prepend_before_filter :authenticate_by_token, unless: :skip_authentication_by_token
  
  before_filter :block_closed_users
  
  protect_from_forgery
  enable_authorization unless: :skip_action?
  
  rescue_from CanCan::Unauthorized, with: :not_authorized
  
  def dashboard
    if admin?
      redirect_to admin_path
    elsif logged_in?
      redirect_to dashboard_path
    else
      redirect_to new_session_path
    end
  end
  
private

  def namespace
    raise 'namespace method should be implemented in controller'
  end
  helper_method :namespace
  
  def admin?
    current_user.admin? if logged_in?
  end
  helper_method :admin?
  
  def not_authenticated
    redirect_to new_session_path
  end
  
  def not_authorized
    path = can?(:show, :dashboards) ? dashboard_path : new_session_path
    redirect_to path, alert: "У вас недостаточно прав для доступа в #{"http://#{request.host}#{request.fullpath}"}"
  end
  
  def after_login_path
    dashboard_path
  end
  
  def skip_action?
    false
  end
  
  def as_role
    admin? ? { as: :admin } : {}
  end
  
  def block_closed_users
    if logged_in? && current_user.closed?
      raise current_user.inspect
      logout
      raise CanCan::Unauthorized
    end
  end
  
  def authenticate_by_token
    if token = params[:token]
      user = User.find_by_token!(token)
      if user.activation_active?
        auto_login user
        redirect_to uri_without_token
      end
    end
  end
  
  def uri_without_token
    uri = URI request.url
    params = Rack::Utils.parse_query uri.query
    params.delete('token')
    uri.query = params.to_param
    uri.to_s
  end
end

# coding: utf-8
class ApplicationController < ActionController::Base
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
end

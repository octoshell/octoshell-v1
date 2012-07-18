class ApplicationController < ActionController::Base
  protect_from_forgery
  # enable_authorization unless: :skip_action?
  
  rescue_from CanCan::Unauthorized, with: :not_authenticated
  
  def dashboard
    redirect_to dashboard_path
  end
  
private

  def namespace
    raise 'namespace method should be implemented in controller'
  end
  helper_method :namespace
  
  def admin?
    current_user.admin?
  end
  helper_method :admin?
  
  def not_authenticated
    redirect_to new_session_path
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

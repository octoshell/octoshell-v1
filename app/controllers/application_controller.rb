class ApplicationController < ActionController::Base
  protect_from_forgery
  enable_authorization unless: :skip_action?
  
  rescue_from CanCan::Unauthorized, with: :not_authenticated
  
  def dashboard
    redirect_to dashboard_path
  end
  
private

  def namespace
    parts = self.class.to_s.split('::')
    if parts.size > 1
      parts.first.downcase
    else
      'base'
    end
  end
  helper_method :namespace
  
  def not_authenticated
    redirect_to new_session_path
  end
  
  def after_login_path
    dashboard_path
  end
  
  def skip_action?
    false
  end
end

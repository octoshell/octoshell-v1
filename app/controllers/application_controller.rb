class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def dashboard
    redirect_to dashboard_path
  end
  
private
  
  def not_authenticated
    redirect_to(new_session_path)
  end
  
  def after_login_path
    dashboard_path
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def user_signed_in?
    !!current_user
  end
  
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  
protected
  
  def not_authenticated
    redirect_to(new_session_path)
  end
end

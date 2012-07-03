class ApplicationController < ActionController::Base
  protect_from_forgery
  
protected
  
  def not_authenticated
    redirect_to(new_session_path)
  end
end

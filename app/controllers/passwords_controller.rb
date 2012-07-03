class PasswordsController < ApplicationController
  before_filter :redirect_to_profile, if: :logged_in?
  
  def new
    @user = User.new
  end
  
  def create
    if @user = User.find_by_email(params[:user][:email])
      @user.deliver_reset_password_instructions!
      redirect_to confirmation_password_path
    else
      redirect_to new_password_path
    end
  end
  
  def confirmation
  end
  
  def edit
    if @user = User.load_from_reset_password_token(params[:token])
      auto_login @user
      redirect_to_profile
    else
      not_authenticated
    end
  end
    
protected
  
  def redirect_to_profile
    redirect_to edit_profile_path
  end
end

class PasswordsController < ApplicationController
  before_filter :redirect_to_profile, if: :logged_in?
  
  def new
    @user = User.new
  end
  
  def create
    if @user = User.find_by_email(params[:user][:email])
      if @user.activation_active?
        @user.deliver_reset_password_instructions!
        redirect_to confirmation_password_path
      else
        flash[:alert] = t('flash.user_is_not_activated')
        redirect_to new_password_path
      end
    else
      flash[:alert] = t('flash.user_not_found')
      redirect_to new_password_path
    end
  end
  
  def confirmation
  end
  
  def change
    if @user = User.load_from_reset_password_token(params[:token])
      auto_login @user
      redirect_to_profile
    else
      not_authenticated
    end
  end
    
private
  
  def redirect_to_profile
    redirect_to edit_profile_path
  end
end

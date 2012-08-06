class ActivationsController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    email = params[:user].delete(:email)
    @user = User.find_by_email(email)
    if @user && @user.activation_pending?
      @user.send :send_activation_needed_email!
      redirect_to new_session_path, notice: t('flash.activation_instructions_sended')
    else
      flash.now[:alert] = if @user
        t('flash.user_is_already_activated')
      else
        t('flash.user_is_not_registered')
      end
      @user = User.new(email: email)
      render :new
    end
  end
end

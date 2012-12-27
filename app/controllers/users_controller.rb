class UsersController < ApplicationController
  before_filter :logout, except: [:email]
  before_filter :setup_default_filter, only: :index
  
  def new
    @user = User.new
  end
    
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.track! :registration, @user, @user
      redirect_to confirmation_users_path(email: @user.email)
    else
      render :new
    end
  end
  
  def activate
    @user = User.load_from_activation_token(params[:token])
    if @user
      @user.activate!
      auto_login @user
      flash[:notice] = t('flash.user_is_activated')
      redirect_to after_login_path
    else
      not_authenticated
    end
  end
  
  def confirmation
  end
  
  def email
    if user = User.find_by_email(params[:email].strip.downcase)
      render json: { full_name: user.full_name }
    else
      render json: {}
    end
  end
  
private
  
  def setup_default_filter
    params[:search] ||= { state_in: ['sured'] }
    params[:search][:meta_sort] ||= 'last_name.asc'
  end
  
  def skip_authentication_by_token
    params[:action] == 'activate'
  end
end

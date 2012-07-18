class UsersController < ApplicationController
  before_filter :logout, except: [:show, :index]
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
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
      redirect_to after_login_path
    else
      not_authenticated
    end
  end
  
  def confirmation
  end
  
private
  
  def namespace
    :dashboard
  end
end

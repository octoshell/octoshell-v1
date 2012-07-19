class UsersController < ApplicationController
  before_filter :require_login, only: [:show, :index, :edit, :update]
  before_filter :logout, except: [:show, :index, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
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
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], as_role)
      redirect_to @user
    else
      render :edit
    end
  end
  
  def confirmation
  end
  
private
  
  def namespace
    :dashboard
  end
end

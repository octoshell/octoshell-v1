class UsersController < ApplicationController
  before_filter :logout
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
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
end

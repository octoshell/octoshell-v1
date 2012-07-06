class SessionsController < ApplicationController
  before_filter :handle_authorized, if: :logged_in?, except: :destroy
  
  def new
    @user = User.new
  end
  
  def create
    email, password, remember = fetch_user(params[:user])    
    if @user = login(email, password, remember)
      redirect_to root_url
    else
      @user = User.new(email: email)
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
  
protected

  def handle_authorized
    redirect_to after_login_path
  end
  
  def fetch_user(hash)
    [hash[:email], hash[:password], hash[:remember]]
  end
end
class SessionsController < ApplicationController
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
  
protected
  
  def fetch_user(hash)
    [hash[:email], hash[:password], hash[:remember]]
  end
end

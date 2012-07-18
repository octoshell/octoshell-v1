class CredentialsController < ApplicationController
  before_filter :require_login
  
  def index
    if current_user.admin?
      @credentials = Credential.all
    else
      @credentials = current_user.credentials
    end
  end
  
  def new
    @credential = find_user.credentials.build
  end
  
  def create
    @credential = find_user.credentials.build(params[:credential])
    if @credential.save
      redirect_to profile_path
    else
      render :new
    end
  end
  
  def destroy
    @credential = Credential.find(params[:id])
    @credential.destroy
    redirect_to profile_path
  end
  
private
  
  def find_user
    current_user
  end
  
  def namespace
    :profile
  end
end

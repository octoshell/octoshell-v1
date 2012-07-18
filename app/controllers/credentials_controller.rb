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
    @credential = Credential.new
  end
  
  def show
    @credential = Credential.find(params[:id])
  end
  
  def create
    @credential = Credential.new(params[:credential], as_role)
    @credential.user = current_user unless admin?
    if @credential.save
      redirect_to @credential
    else
      render :new
    end
  end
  
  def destroy
    @credential = Credential.find(params[:id])
    @credential.destroy
    redirect_to credentials_path
  end
  
private
  
  def find_user
    current_user
  end
  
  def namespace
    :profile
  end
end

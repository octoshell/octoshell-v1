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
    @credential.user = current_user unless admin?
  end
  
  def show
    @credential = Credential.find(params[:id])
    authorize! :show, @credential
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
    authorize! :destroy, @credential
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

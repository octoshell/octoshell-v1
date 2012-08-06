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
  
  def close
    @credential = Credential.find(params[:credential_id])
    authorize! :close, @credential
    if @credential.close
      redirect_to @credential
    else
      flash.now[:alert] = @credential.errors.full_messages.join(', ')
      render :show
    end
  end
  
private
  
  def find_user
    current_user
  end
  
  def namespace
    admin? ? :admin : :profile
  end
end

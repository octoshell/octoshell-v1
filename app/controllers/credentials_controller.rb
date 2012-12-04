class CredentialsController < ApplicationController
  before_filter :require_login
  
  def new
    @credential = current_user.credentials.build
  end
    
  def create
    @credential = current_user.credentials.build(params[:credential])
    if @credential.save
      @credential.user.track! :create_credential, @credential, current_user
      redirect_to @credential
    else
      render :new
    end
  end
  
  def close
    @credential = Credential.find(params[:credential_id])
    authorize! :close_own, @credential
    if @credential.close
      @credential.user.track! :close_credential, @credential, current_user
      redirect_to credentials_path
    else
      flash.now[:alert] = @credential.errors.full_messages.join(', ')
      render :show
    end
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

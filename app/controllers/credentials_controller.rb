class CredentialsController < ApplicationController
  before_filter :require_login
  
  def new
    @credential = current_user.credentials.build
  end
    
  def create
    @credential = current_user.credentials.build(params[:credential])
    if @credential.activate_or_create
      @credential.user.track! :create_credential, @credential, current_user
      redirect_to profile_path
    else
      render :new
    end
  end
  
  def close
    @credential = Credential.find(params[:credential_id])
    if @credential.close
      @credential.user.track! :close_credential, @credential, current_user
      redirect_to profile_path
    else
      flash.now[:alert] = @credential.errors.full_messages.join(', ')
      render :show
    end
  end
  
private
  
  def namespace
    :dashboard
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end

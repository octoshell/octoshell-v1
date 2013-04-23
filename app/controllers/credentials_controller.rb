class CredentialsController < ApplicationController
  before_filter :require_login
  
  def new
    add_breadcrumb 'Профиль', profile_path
    add_breadcrumb 'Новый публичный ключ'
    @credential = current_user.credentials.build
  end
    
  def create
    @credential = current_user.credentials.build(params[:credential])
    if @credential.activate_or_create
      @credential.user.track! :create_credential, @credential, current_user
      redirect_to profile_path
    else
      add_breadcrumb 'Профиль', profile_path
      add_breadcrumb 'Новый публичный ключ'
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
    :profile
  end
end

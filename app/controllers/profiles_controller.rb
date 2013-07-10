class ProfilesController < ApplicationController
  before_filter :require_login
  
  def show
    @user = find_user
    @user.extend(Avatarable)
  end
  
  def edit
    add_breadcrumb 'Профиль', profile_path
    add_breadcrumb 'Редактирование'
    @user = find_user
    @user.additional_emails.build
  end
  
  def update
    @user = find_user
    if @user.update_attributes(params[:user], as: :admin)
      @user.track! :update_profile, @user, @user
      redirect_to profile_path
    else
      render :edit
    end
  end

private
  
  def find_user
    current_user
  end
  
  def namespace
    may?(:access, :admin) ? :dashboard : :profile
  end
end

class ProfilesController < ApplicationController
  before_filter :require_login
  
  def show
    @user = find_user
  end
  
  def edit
    @user = find_user
  end
  
  def update
    @user = find_user
    if @user.update_attributes(params[:user], as_role)
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
    :profile
  end
end

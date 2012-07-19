class DashboardsController < ApplicationController
  before_filter :require_login
  
  def show
    @user = current_user
  end
  
private
  
  def namespace
    :dashboard
  end
end

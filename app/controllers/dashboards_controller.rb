class DashboardsController < ApplicationController
  before_filter :require_login
  before_filter :handle_admin
  
  def show
    redirect_to projects_path
  end
  
private
  
  def namespace
    :dashboard
  end
  
  def handle_admin
    redirect_to admin_path if admin?
  end
end

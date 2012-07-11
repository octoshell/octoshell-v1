class Admin::BaseController < ApplicationController
  before_filter :require_login, :require_admin
  
  def dashboard
    redirect_to admin_dashboard_path
  end

private
  
  def require_admin
    authorize! :access, :admin
  end
end

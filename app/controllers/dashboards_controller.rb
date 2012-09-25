class DashboardsController < ApplicationController
  before_filter :require_login
  before_filter :handle_admin
  
  def show
    @user = current_user
    @sureties = @user.sureties.pending
    @requests = @user.requests.pending
    @tickets = @user.tickets.answered
  end
  
private
  
  def namespace
    :dashboard
  end
  
  def handle_admin
    redirect_to admin_path if admin?
  end
end

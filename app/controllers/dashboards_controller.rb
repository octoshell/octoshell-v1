class DashboardsController < ApplicationController
  before_filter :require_login
  
  def show
    @requests = current_user.requests.includes(:cluster).last(5)
    @projects = current_user.projects
    @accounts = current_user.all_accounts.order('id desc')
  end
  
private
  
  def namespace
    :dashboard
  end
end

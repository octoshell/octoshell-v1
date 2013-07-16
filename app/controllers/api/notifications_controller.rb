class Api::NotificationsController < Api::ApplicationController
  def create
    @notification = Notification.new(params[:notification], as: :admin)
    if @notification.save
      render(json: {
        id:    @notification.id,
        title: @notification.title,
        body:  @notification.body
      }, status: 201)
    else
      render nothing: true, status: 422
    end
  end
  
  def deliver
    @notification = Notification.find(params[:id])
    @notification.deliver!
    render nothing: true
  end
  
  def add_all_users
    @notification = Notification.find(params[:id])
    @notification.add_all_recipients
    render nothing: true
  end
  
  def add_from_cluster
    @notification = Notification.find(params[:id])
    @notification.add_from_cluster(params[:cluster_id])
    render nothing: true
  end
  
  def add_from_organization_kind
    @notification = Notification.find(params[:id])
    @notification.add_from_organization_kind(params[:organization_kind_id])
    render nothing: true
  end
  
  def add_from_organization
    @notification = Notification.find(params[:id])
    @notification.add_from_organization(params[:organization_id])
    render nothing: true
  end
  
  def add_from_project
    @notification = Notification.find(params[:id])
    @notification.add_from_project(params[:project_id])
    render nothing: true
  end
  
  def add_with_projects
    @notification = Notification.find(params[:id])
    @notification.add_with_projects
    render nothing: true
  end
  
  def add_with_accounts
    @notification = Notification.find(params[:id])
    @notification.add_with_accounts
    render nothing: true
  end
  
  def add_with_refused_accounts
    @notification = Notification.find(params[:id])
    @notification.add_with_refused_accounts
    render nothing: true
  end
  
  def add_from_session
    @notification = Notification.find(params[:id])
    @notification.add_from_session(params[:session_id])
    render nothing: true
  end
  
  def add_unsuccessful_of_current_session
    @notification = Notification.find(params[:id])
    @notification.add_unsuccessful_of_current_session
    render nothing: true
  end
  
  def add_user
    @notification = Notification.find(params[:id])
    @notification.add_user(params[:user_id])
    render nothing: true
  end
end

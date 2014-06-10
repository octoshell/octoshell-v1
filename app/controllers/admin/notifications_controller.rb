class Admin::NotificationsController < Admin::ApplicationController
  before_filter { authorize! :manage, :notifications }

  def index
    @notifications = Notification.order("id desc")
  end

  def show
    @notification = Notification.find(params[:id])
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification], as: :admin)
    if @notification.save
      redirect_to [:admin, @notification]
    else
      render :new
    end
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.find(params[:id])
    if @notification.update_attributes(params[:notification], as: :admin)
      redirect_to [:admin, @notification]
    else
      render :edit
    end
  end

  def deliver
    @notification = Notification.find(params[:notification_id])
    @notification.deliver
    redirect_to admin_notifications_path
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to admin_notifications_path
  end

  def test
    @notification = Notification.find(params[:notification_id])
    @notification.test_send(current_user)
    redirect_to [:admin, @notification]
  end

  def add_all_recipients
    @notification = Notification.find(params[:notification_id])
    @notification.add_all_recipients
    redirect_to [:admin, @notification]
  end

  def remove_all_recipients
    @notification = Notification.find(params[:notification_id])
    @notification.remove_all_recipients
    redirect_to [:admin, @notification]
  end

  def add_from_cluster
    @notification = Notification.find(params[:notification_id])
    @notification.add_from_cluster(params[:id])
    redirect_to [:admin, @notification]
  end

  def add_with_projects
    @notification = Notification.find(params[:notification_id])
    @notification.add_with_projects
    redirect_to [:admin, @notification]
  end

  def add_with_accounts
    @notification = Notification.find(params[:notification_id])
    @notification.add_with_accounts
    redirect_to [:admin, @notification]
  end

  def add_with_refused_accounts
    @notification = Notification.find(params[:notification_id])
    @notification.add_with_refused_accounts
    redirect_to [:admin, @notification]
  end

  def add_from_session
    @notification = Notification.find(params[:notification_id])
    @notification.add_from_session(params[:id])
    redirect_to [:admin, @notification]
  end

  def add_unsuccessful_of_current_session
    @notification = Notification.find(params[:notification_id])
    @notification.add_unsuccessful_of_current_session
    redirect_to [:admin, @notification]
  end

  def add_from_project
    @notification = Notification.find(params[:notification_id])
    @notification.add_from_project(params[:project_id])
    redirect_to [:admin, @notification]
  end

  def add_from_organization
    @notification = Notification.find(params[:notification_id])
    @notification.add_from_organization(params[:organization_id])
    redirect_to [:admin, @notification]
  end

  def add_from_organization_kind
    @notification = Notification.find(params[:notification_id])
    @notification.add_from_organization_kind(params[:organization_kind_id])
    redirect_to [:admin, @notification]
  end

  def add_all_info_subscribers
    @notification = Notification.find(params[:notification_id])
    @notification.add_all_info_subscribers
    redirect_to [:admin, @notification]
  end

  private
  def default_breadcrumb
    false
  end
end

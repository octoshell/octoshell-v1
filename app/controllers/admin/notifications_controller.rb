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
  
  private
  def default_breadcrumb
    false
  end
end

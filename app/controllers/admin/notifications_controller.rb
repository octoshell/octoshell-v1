class Admin::NotificationsController < Admin::ApplicationController
  def index
    @notifications = Notification.order("id desc")
  end
  
  def new
    @notification = Notification.new
  end
  
  def create
    @notification = Notification.new(params[:notification], as: :admin)
    if @notification.save
      redirect_to admin_notifications_path
    else
      render :new
    end
  end
  
  def deliver
    @notification = Notification.find(params[:id])
    
  end
  
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_to admin_notifications_path
  end
end

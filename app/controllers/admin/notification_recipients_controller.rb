class Admin::NotificationRecipientsController < Admin::ApplicationController
  before_filter { authorize! :manage, :notifications }

  def create
    @notification = Notification.find(params[:notification_id])
    @notification.recipients.where(user_id: params[:user_id]).first_or_create!
    redirect_to [:admin, @notification]
  end

  def destroy
    nr = Notification::Recipient.find(params[:id]).destroy
    redirect_to [:admin, nr.notification]
  end
end

class NotificationRecipientsController < ApplicationController
  before_filter { authorize! :manage, :notifications }
  
  def destroy
    nr = Notification::Recipient.find(params[:id]).destroy
    redirect_to [:admin, nr.notification]
  end
end

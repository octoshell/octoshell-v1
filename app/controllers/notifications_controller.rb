class NotificationsController < ApplicationController
  def index
    @user = current_user
    @sureties = @user.sureties.pending
    @requests = @user.requests.pending
    @tickets = @user.tickets.answered
  end
  
private
  
  def namespace
    :notifications
  end
end

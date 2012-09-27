class NotificationsController < ApplicationController
  def index
    if admin?
      @requests = Request.pending
      @tasks = Task.failed
      @sureties = Surety.pending
      @tickets = Ticket.active
    else
      @user = current_user
      @sureties = @user.sureties.pending
      @requests = @user.requests.pending
      @tickets = @user.tickets.answered
    end
  end
  
private
  
  def namespace
    :notifications
  end
end

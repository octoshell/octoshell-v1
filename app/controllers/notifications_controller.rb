class NotificationsController < ApplicationController
  before_filter :require_login

  def index
    if may? :access, :admin
      @tasks = Task.failed
      @tickets = Ticket.active
      @sureties = Surety.pending
      @requests = Request.pending
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

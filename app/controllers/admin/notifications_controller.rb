class Admin::NotificationsController < Admin::ApplicationController
  def index
    @requests = Request.pending
    @tasks = Task.failed
    @sureties = Surety.pending
    @tickets = Ticket.active
  end
  
private
  
  def namespace
    :notifications
  end
end

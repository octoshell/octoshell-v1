class NotificationsController < ApplicationController
  before_filter :require_login

  def index
    if may? :access, :admin
      @tasks = Task.failed
      @tickets = Ticket.active
      @sureties = Surety.pending
      @requests = Request.pending
    end
  end
  
private
  
  def namespace
    :notifications
  end
end

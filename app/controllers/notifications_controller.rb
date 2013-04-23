class NotificationsController < ApplicationController
  before_filter :require_login

  def index
    authorize! :access, :admin
    @tasks = Task.with_state(:failed)
    @tickets = Ticket.with_state(:active)
    @sureties = Surety.with_state(:generated)
    @requests = Request.with_state(:pending)
  end
  
private
  
  def namespace
    :notifications
  end
end

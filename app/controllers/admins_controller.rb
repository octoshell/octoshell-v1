class AdminsController < ApplicationController
  before_filter :require_login
  
  def show
    @requests = Request.pending
    @tasks = Task.failed
    @sureties = Surety.pending
    @tickets = Ticket.active
  end
  
private
  
  def namespace
    :admin
  end
end

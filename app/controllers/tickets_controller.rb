class TicketsController < ApplicationController
  before_filter :require_login
  
  def index
    if admin?
      @tickets = Ticket.scoped
    else
      @tickets = current_user.tickets
    end
  end
  
  def closed
    if admin?
      @tickets = Ticket.closed
    else
      @tickets = current_user.tickets.closed
    end
  end
  
  def new
    @ticket = Ticket.new
    @ticket.user = current_user unless admin?
    authorize! :new, @ticket
  end
  
  def create
    @ticket = Ticket.new(params[:ticket], as_role)
    @ticket.user = current_user unless admin?
    authorize! :create, @ticket
    if @ticket.save
      redirect_to @ticket
    else
      render :new
    end
  end
  
  def show
    @ticket = Ticket.find(params[:id])
    @replies = @ticket.replies.dup
    @reply = @ticket.replies.build do |reply|
      reply.user = current_user
    end
    authorize! :show, @ticket
  end
  
  def close
    @ticket = Ticket.find(params[:ticket_id])
    authorize! :close, @ticket
    if @ticket.close
      redirect_to @ticket
    else
      redirect_to @ticket, alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
  def resolve
    @ticket = Ticket.find(params[:ticket_id])
    authorize! :resolve, @ticket
    if @ticket.resolve
      redirect_to @ticket
    else
      redirect_to @ticket, alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
private
  
  def namespace
    :support
  end  
end

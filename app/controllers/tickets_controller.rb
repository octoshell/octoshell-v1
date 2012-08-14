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
    flash.now[:info] = params[:info] if params[:info].present?
    @ticket = Ticket.new(params[:ticket])
    @ticket.user = current_user unless admin?
    @projects = admin? ? Project.all : current_user.projects
    authorize! :new, @ticket
  end
  
  def continue
    @ticket = Ticket.new(params[:ticket], as_role)
    @ticket.user = current_user unless admin?
    if @ticket.show_form?
      @ticket.ticket_question.ticket_field_relations.uses.each do |relation|
        @ticket.ticket_field_values.build do |value|
          value.ticket_field_relation = relation
        end
      end
    end
    authorize! :continue, @ticket
    render :new
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
  
  def edit
    @ticket = Ticket.find(params[:id])
  end
  
  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update_attributes(params[:ticket], as_role)
      redirect_to @ticket
    else
      render :edit
    end
  end
  
private
  
  def namespace
    :support
  end  
end

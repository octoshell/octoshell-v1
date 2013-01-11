# coding: utf-8
class Admin::TicketsController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    if admin?
      @search = Ticket.search(params[:search])
      @tickets = show_all? ? @search.relation.uniq : @search.relation.uniq.page(params[:page])
    else
      @search = current_user.tickets.search(params[:search])
      @tickets = @search.relation.uniq.page(params[:page])
    end
  end
  
  def closed
    if admin?
      @tickets = Ticket.closed
    else
      @tickets = current_user.tickets.closed
    end
  end
    
  def show
    @ticket = Ticket.find(params[:id])
    @replies = @ticket.replies.dup
    @reply = @ticket.replies.build do |reply|
      reply.user = current_user
    end
    @ticket_tag = TicketTag.new
    authorize! :show, @ticket
  end
  
  def close
    @ticket = Ticket.find(params[:ticket_id])
    authorize! :close, @ticket
    if @ticket.close
      @ticket.user.track! :close_ticket, @ticket, current_user
      redirect_to @ticket
    else
      redirect_to @ticket, alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
  def resolve
    @ticket = Ticket.find(params[:ticket_id])
    authorize! :resolve, @ticket
    if @ticket.resolve
      @ticket.user.track! :resolve_ticket, @ticket, current_user
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
      @ticket.user.track! :update_ticket, @ticket, current_user
      redirect_to @ticket
    else
      render :edit
    end
  end
  
  def tag_relations_form
    @ticket = Ticket.find(params[:ticket_id])
    render partial: 'tag_relations_form', locals: { ticket: @ticket }
  end
  
private

  def setup_default_filter
    states = admin? ? ['active'] : ['active', 'answered', 'resolved']
    params[:search] ||= { state_in: states }
    params[:meta_sort] ||= 'id.asc'
    if admin?
      params[:search][:ticket_tag_relations_ticket_tag_name_in] ||= TicketTag.active.pluck(:name)
    end
  end
end

# coding: utf-8
class TicketsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = current_user.tickets.search(params[:q])
    @tickets = @search.relation.uniq.page(params[:page])
  end
  
  def new
    @ticket = current_user.tickets.build(params[:ticket])
    @projects = current_user.all_projects
  end
  
  def continue
    @ticket = current_user.tickets.build(params[:ticket])
    if @ticket.show_form?
      @ticket.ticket_question.ticket_field_relations.uses.each do |relation|
        @ticket.ticket_field_values.build do |value|
          value.ticket_field_relation = relation
        end
      end
    end
    render :new
  end
  
  def create
    @ticket = current_user.tickets.build(params[:ticket])
    if @ticket.save
      @ticket.user.track! :create_ticket, @ticket, current_user
      redirect_to @ticket, notice: t('.ticket_created')
    else
      render :new
    end
  end
  
  def show
    @ticket = find_ticket(params[:id])
    @replies = @ticket.replies.dup
    @reply = @ticket.replies.build do |reply|
      reply.user = current_user
    end
    @ticket_tag = TicketTag.new
  end
  
  def close
    @ticket = find_ticket(params[:ticket_id])
    if @ticket.close
      @ticket.user.track! :close_ticket, @ticket, current_user
      redirect_to @ticket
    else
      redirect_to @ticket, alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
  def resolve
    @ticket = find_ticket(params[:ticket_id])
    if @ticket.resolve
      @ticket.user.track! :resolve_ticket, @ticket, current_user
      redirect_to @ticket
    else
      redirect_to @ticket, alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
  def edit
    @ticket = find_ticket(params[:id])
  end
  
  def update
    @ticket = find_ticket(params[:id])
    if @ticket.update_attributes(params[:ticket], as: :admin)
      @ticket.user.track! :update_ticket, @ticket, current_user
      redirect_to @ticket
    else
      render :edit
    end
  end
  
private

  def find_ticket(id)
    current_user.tickets.find(id)
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active', 'answered', 'resolved'] }
    params[:meta_sort] ||= 'id.asc'
  end
end

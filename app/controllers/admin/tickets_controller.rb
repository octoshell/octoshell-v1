# coding: utf-8
class Admin::TicketsController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Ticket.search(params[:q])
    @tickets = show_all? ? @search.relation.uniq : @search.relation.uniq.page(params[:page])
  end
    
  def show
    @ticket = Ticket.find(params[:id])
    @replies = @ticket.replies.dup
    @reply = @ticket.replies.build do |reply|
      reply.user = current_user
    end
    @ticket_tag = TicketTag.new
  end
  
  def close
    @ticket = Ticket.find(params[:ticket_id])
    if @ticket.close
      @ticket.user.track! :close_ticket, @ticket, current_user
      redirect_to [:admin, @ticket]
    else
      redirect_to [:admin, @ticket], alert: @ticket.errors.full_messages.join(', ')
    end
  end
  
  def edit
    @ticket = Ticket.find(params[:id])
  end
  
  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update_attributes(params[:ticket], as: :admin)
      @ticket.user.track! :update_ticket, @ticket, current_user
      redirect_to [:admin, @ticket]
    else
      render :edit
    end
  end
  
  def tag_relations_form
    @ticket = Ticket.find(params[:ticket_id])
    render partial: 'tag_relations_form', locals: { ticket: @ticket }
  end

  def accept
    @ticket = Ticket.find(params[:ticket_id])
    @ticket.accept(current_user)
    redirect_to [:admin, @ticket]
  end
  
private

  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
    params[:q][:meta_sort] ||= 'id.asc'
    params[:q][:ticket_tag_relations_ticket_tag_name_in] ||= TicketTag.active.pluck(:name)
  end
end

# coding: utf-8
class Admin::TicketsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index

  def index
    @search = Ticket.search(params[:q])
    search_result = @search.result(distinct: true).order("id DESC, updated_at DESC")
    @tickets = show_all? ? search_result : search_result.page(params[:page])

    # записываем отрисованные тикеты в куки, для перехода к следующему тикету после ответа
    cookies[:tickets_list] = @tickets.map(&:id).join(',')
  end

  def show
    @ticket = Ticket.find(params[:id])
    @next_ticket = @ticket.find_next_ticket_from(cookies[:tickets_list])
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

  def reactivate
    @ticket = Ticket.find(params[:ticket_id])
    if @ticket.reactivate
      @ticket.user.track! :reactivate_ticket, @ticket, current_user
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

  def update_subscribers
    @ticket = Ticket.find(params[:ticket_id])
    @ticket.update_attributes(params[:ticket], as: :admin)
    @ticket.user.track! :update_ticket_subscribers, @ticket, current_user
    render partial: 'ticket_subscribers', locals: { ticket: @ticket }
  end

  def accept
    @ticket = Ticket.find(params[:ticket_id])
    @ticket.accept(current_user)
    redirect_to [:admin, @ticket]
  end

private

  def default_breadcrumb
    false
  end

  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end

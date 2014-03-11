class Admin::RepliesController < Admin::ApplicationController
  before_filter { authorize! :manage, :reports }
  
  def create
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    if @reply.save
      @reply.user.track! :create_reply, @reply, current_user

      if params[:show_self].present?
        redirect_to [:admin, @reply.ticket]
      elsif params[:show_next].present?
        redirect_to next_ticket_path
      else
        redirect_to admin_tickets_path
      end
    else
      @ticket = @reply.ticket
      @replies = @ticket.replies
      render 'tickets/show'
    end
  end

  def next_ticket_path
    next_ticket = @reply.ticket.find_next_ticket_from(cookies[:tickets_list])
    if next_ticket
      [:admin, next_ticket]
    else
      # прошли по всему доступному списку ранее отрисованных тикетов, показываем новый
      admin_tickets_path
    end
  end
end

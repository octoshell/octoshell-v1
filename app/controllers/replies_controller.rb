class RepliesController < ApplicationController
  before_filter :require_login
  
  def create
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    if current_user.ticket_ids.include?(@reply.ticket_id) && @reply.save
      @reply.user.track! :create_reply, @reply, current_user
      redirect_to @reply.ticket
    else
      @ticket = @reply.ticket
      @replies = @ticket.replies
      render 'tickets/show'
    end
  end

private

  def namespace
    :dashboard
  end
end

class RepliesController < ApplicationController
  def create
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    authorize! :create, @reply
    if @reply.save
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
    :support
  end
end

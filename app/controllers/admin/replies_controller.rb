class Admin::RepliesController < Admin::ApplicationController
  def create
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    if @reply.save
      @reply.user.track! :create_reply, @reply, current_user
      redirect_to @reply.ticket
    else
      @ticket = @reply.ticket
      @replies = @ticket.replies
      render 'tickets/show'
    end
  end
end

class Admin::RepliesController < Admin::ApplicationController
  before_filter { authorize! :manage, :reports }
  
  def create
    @reply = Reply.new(params[:reply])
    @reply.user = current_user
    if @reply.save
      @reply.user.track! :create_reply, @reply, current_user
      redirect_to admin_tickets_path
    else
      @ticket = @reply.ticket
      @replies = @ticket.replies
      render 'tickets/show'
    end
  end
end

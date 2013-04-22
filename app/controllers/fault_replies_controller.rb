class FaultRepliesController < ApplicationController
  before_filter :require_login
  
  def create
    @fault = current_user.faults.find(params[:fault_id])
    @reply = @fault.replies.build(params[:fault_reply]) do |f|
      f.user = current_user
    end
    if @reply.save
      redirect_to @fault
    else
      render 'faults/show'
    end
  end
end

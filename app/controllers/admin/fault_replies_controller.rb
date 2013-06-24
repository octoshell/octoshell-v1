class Admin::FaultRepliesController < Admin::ApplicationController
  def create
    @fault = Fault.find(params[:fault_id])
    @reply = @fault.replies.build(params[:fault_reply]) do |f|
      f.user = current_user
    end
    if @reply.save
      redirect_to [:admin, @fault]
    else
      render 'admin/faults/show'
    end
  end
end

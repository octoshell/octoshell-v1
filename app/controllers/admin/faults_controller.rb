class Admin::FaultsController < Admin::ApplicationController
  def show
    @fault = Fault.find(params[:id])
    @reply = @fault.replies.build do |r|
      r.user = current_user
    end
  end
  
  def resolve
    authorize! :resolve, :faults
    @fault = Fault.find(params[:fault_id])
    if @fault.resolved? || @fault.resolve
      redirect_to [:admin, @fault.user]
    else
      @reply = @fault.replies.build do |r|
        r.user = current_user
      end
      render :show
    end
  end
end

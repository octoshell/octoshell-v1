class Admin::FaultsController < Admin::ApplicationController
  before_filter { authorize! :manage, :users }
  
  def show
    @fault = Fault.find(params[:id])
    @reply = @fault.replies.build do |r|
      r.user = current_user
    end
    
    add_breadcrumb @fault.user.full_name, [:admin, @fault.user]
    add_breadcrumb "Проблемы"
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
  
  private
  def default_breadcrumb
    false
  end
end

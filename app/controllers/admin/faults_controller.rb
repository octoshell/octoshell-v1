class Admin::FaultsController < Admin::ApplicationController
  before_filter { authorize! :manage, :users }

  def index
    @search = Fault.search(params[:q])
    search_result = @search.result(distinct: true).includes(:user)
    @faults = show_all? ? search_result : search_result.page(params[:page])
  end
  
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
      if @fault.kind_of_block == "user"
        redirect_to [:admin, @fault.user]
      else
        redirect_to [:admin, @fault.reference.is_a?(Project) ? @fault.reference : @fault.reference.project]
      end
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

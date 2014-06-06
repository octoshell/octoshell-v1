class Admin::TasksController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Task.search(params[:q])
    search_result = @search.result(distinct: true)
    @tasks = show_all? ? search_result : search_result.page(params[:page])
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def retry
    @task = Task.find(params[:task_id])
    @task.retry
    redirect_to [:admin, @task]
  end
  
  def resolve
    @task = Task.find(params[:task_id])
    @task.resolve
    redirect_to [:admin, @task]
  end
  
  def perform_callbacks
    @task = Task.find(params[:task_id])
    if @task.perform_callbacks!
      redirect_to [:admin, @task]
    else
      redirect_to [:admin, @task], alert: @task.errors.full_messages.join("\n")
    end
  end
  
private
  
  def setup_default_filter
    params[:q] ||= {
      state_in: ['failed'],
      procedure_in: Task::PROCEDURES,
      resource_type_in: Task.human_resource_types.map(&:last)
    }
  end
end

class TasksController < ApplicationController
  before_filter :require_login
  
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Task.search(params[:search])
    @tasks = @search.page(params[:page])
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @base_task = Task.find(params[:task_id])
    @task = Task.new do |task|
      task.command = @base_task.command
      task.resource = @base_task.resource
      task.procedure = @base_task.procedure
    end
  end
  
  def retry
    @task = Task.find(params[:task_id])
    if @task.retry(params[:task], as_role)
      redirect_to @task
    else
      render :new
    end
  end
  
  def perform_callbacks
    @task = Task.find(params[:task_id])
    if @task.perform_callbacks!
      redirect_to @task
    else
      redirect_to @task, alert: @task.errors.full_messages.join("\n")
    end
  end
  
private
  
  def namespace
    :admin
  end
  
  def setup_default_filter
    params[:search] ||= {
      state_in: ['pending'],
      procedure_in: Task::PROCEDURES,
      resource_type_in: Task.human_resource_types.map(&:last)
    }
  end
end

class TasksController < ApplicationController
  before_filter :require_login
  
  def index
    @tasks = Task.order('id desc')
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def retry
    @task = Task.find(params[:task_id]).retry
  end
  
  def create
    @task = Task.new(params[:task], as_role)
    if @task.retry!
      redirect_to @task
    else
      render :retry
    end
  end
  
  def success
    @task = Task.find(params[:task_id])
    if @task.force_success
      redirect_to @task
    else
      redirect_to @task, alert: @task.errors.full_messages.join("\n")
    end
  end
  
private
  
  def namespace
    :admin
  end
end

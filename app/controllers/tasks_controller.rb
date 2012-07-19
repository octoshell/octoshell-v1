class TasksController < ApplicationController
  before_filter :require_login
  
  def index
    @tasks = Task.order('id desc')
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
private
  
  def namespace
    :admin
  end
end

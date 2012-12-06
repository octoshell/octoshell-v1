class RequestsController < ApplicationController
  before_filter :require_login
  
  def index
    @requests = current_user.requests
  end
  
  def new
    @request = current_user.requests.build(project_id: params[:project_id])
    @projects = @request.allowed_projects
  end
  
  def create
    current_user.requests.build(params[:request])
    if @request.save
      @request.user.track! :create_request, @request, current_user
      redirect_to @request
    else
      @projects = @request.allowed_projects
      render :new
    end
  end
  
  def edit
    @request = find_request(params[:id])
    @projects = @request.allowed_projects
  end
  
  def update
    @request = find_request(params[:id])
    @projects = @request.allowed_projects
    if @request.update_attributes(params[:request])
      @request.user.track! :update_request, @request, current_user
      redirect_to @request
    else
      @projects = @request.allowed_projects
      render :edit
    end
  end
  
  def show
    @request = find_request(params[:id])
  end

private
  
  def redirect_to_request(request)
    redirect_to request
  end
  
  def redirect_to_request_with_alert(request)
    redirect_to request, alert: request.errors.full_messages.join(', ')
  end
  
  def find_request(id)
    current_user.requests.find(id)
  end
  
  def namespace
    :dashboard
  end
end

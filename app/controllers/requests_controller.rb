class RequestsController < ApplicationController
  before_filter :require_login
  
  def index
    @requests = current_user.requests
  end
  
  def new
    @project = current_user.owned_projects.find(params[:project_id])
    @cluster = Cluster.find(params[:cluster_id])
    @request = current_user.requests.build do |request|
      request.project = @project
      request.cluster = @cluster
    end
  end
  
  def create
    @project = current_user.owned_projects.find(params[:project_id])
    @cluster = Cluster.find(params[:cluster_id])
    @request = current_user.requests.build(params[:request]) do |request|
      request.project = @project
      request.cluster = @cluster
    end
    if @request.save
      @request.user.track! :create_request, @request, current_user
      redirect_to @request, notice: t('.request_created', default: 'Request successfuly created')
    else
      flash.now[:error] = t('.failed_create_request', default: "You can't create a new request until active one exists")
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

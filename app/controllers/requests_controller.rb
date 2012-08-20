class RequestsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Request.search(params[:search])
    @requests = @search.page(params[:page])
  end
  
  def new
    @request = Request.new
    if admin?
      @projects = Project.active
    else
      @request.user = current_user
      @projects = @request.allowed_projects
    end
  end
  
  def create
    @request = Request.new(params[:request], as_role)
    @request.user = current_user unless admin?
    if @request.save
      redirect_to @request
    else
      if admin?
        @projects = Project.active
      else
        @projects = @request.allowed_projects
      end
      render :new
    end
  end
  
  def show
    @request = find_request(params[:id])
    authorize! :show, @request
  end
  
  def activate
    @request = find_request(params[:request_id])
    if @request.activate
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
  def decline
    @request = find_request(params[:request_id])
    if @request.decline
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
  def close
    @request = find_request(params[:request_id])
    if @request.close
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
private
  
  def redirect_to_request(request)
    redirect_to request
  end
  
  def redirect_to_request_with_alert(request)
    redirect_to request, alert: request.errors.full_messages.join(', ')
  end
  
  def find_request(id)
    Request.find(id)
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['pending', 'active'] }
  end
end

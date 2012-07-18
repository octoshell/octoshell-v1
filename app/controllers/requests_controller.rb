class RequestsController < ApplicationController
  before_filter :require_login
  
  def index
    @requests = Request.scoped
  end
  
  def new
    @request = current_user.requests.build
  end
  
  def create
    @request = current_user.requests.build(params[:request], as_role)
    if @request.save
      redirect_to @request
    else
      render :new
    end
  end
  
  def show
    @request = find_request(params[:id])
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
  
  def finish
    @request = find_request(params[:request_id])
    if @request.finish
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
    current_user.admin? ? :admin : :dashboard
  end
end

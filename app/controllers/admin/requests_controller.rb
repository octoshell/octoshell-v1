class Admin::RequestsController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Request.order("id desc").search(params[:q]).result(distinct: true)
    @requests = show_all? ? @search : @search.page(params[:page])
  end
  
  def edit
    @request = find_request(params[:id])
    @projects = @request.allowed_projects
  end
  
  def update
    @request = find_request(params[:id])
    @projects = @request.allowed_projects
    if @request.update_attributes(params[:request], as: :admin)
      @request.user.track! :update_request, @request, current_user
      redirect_to_request(@request)
    else
      @projects = @request.allowed_projects
      render :edit
    end
  end
  
  def show
    @request = find_request(params[:id])
    add_breadcrumb "Список", admin_requests_path
    add_breadcrumb "Заявка ##{@request.id}"
  end
  
  def activate
    @request = find_request(params[:request_id])
    if @request.activate
      @request.user.track! :activate_request, @request, current_user
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
  def decline
    @request = find_request(params[:request_id])
    if @request.decline
      @request.user.track! :decline_request, @request, current_user
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
  def close
    @request = find_request(params[:request_id])
    if @request.close
      @request.user.track! :close_request, @request, current_user
      redirect_to_request(@request)
    else
      redirect_to_request_with_alert(@request)
    end
  end
  
private

  def default_breadcrumb
    false
  end
  
  def redirect_to_request(request)
    redirect_to [:admin, request]
  end
  
  def redirect_to_request_with_alert(request)
    redirect_to [:admin, request], alert: request.errors.full_messages.join(', ')
  end
  
  def find_request(id)
    Request.find(id)
  end

  def setup_default_filter
    params[:q] ||= { state_in: ['pending'] }
  end
end

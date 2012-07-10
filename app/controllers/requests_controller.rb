class RequestsController < ApplicationController
  before_filter :require_login
  
  def new
    @request = current_user.requests.build
  end
  
  def create
    @request = current_user.requests.build(params[:request])
    if @request.save
      redirect_to dashboard_path
    else
      render :new
    end
  end
  
private
  
  def find_request(id)
    current_user.all_requests.find(id)
  end
end

class RequestsController < ApplicationController
  before_filter :require_login
  
  def show
    @request = current_user.requests.find(params[:id])
    add_breadcrumb @request.project.title, @request.project
    add_breadcrumb "Заявка ##{@request.id}"
  end
  
  def create
    @request = current_user.requests.build(params[:request])
    if @request.save
      @request.project.user.track! :create_request, @request, current_user
      redirect_to @request.project, notice: 'Заявка создана'
    else
      redirect_to @request.project, alert: @request.errors.full_messages.to_sentence
    end
  end
  
  def close
    @request = current_user.requests.find(params[:request_id])
    if @request.closed? || @request.close
      redirect_to @request.project, notice: "Заявка на ресурсы кластера #{@request.cluster.name} закрыта"
    else
      redirect_to @request, alert: @request.errors.full_messages.to_sentence
    end
  end
end

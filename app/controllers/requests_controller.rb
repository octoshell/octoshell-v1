class RequestsController < ApplicationController
  before_filter :require_login
  
  def create
    @request = current_user.requests.build(params[:request])
    if @request.save
      @request.project.user.track! :create_request, @request, current_user
      redirect_to @request.project, notice: 'Заявка создана'
    else
      redirect_to @request.project, alert: @request.errors.full_messages.to_sentence
    end
  end
end

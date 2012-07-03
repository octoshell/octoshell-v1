class RequestsController < ApplicationController
  def confirmation
    @request = find_request(params[:request_id])
  end
  
protected
  
  def find_request(id)
    Request.find id
  end
end

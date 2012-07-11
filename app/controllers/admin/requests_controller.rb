module Admin
  class RequestsController < BaseController
    def index
      @requests = Request.order('id desc')
    end
    
    def show
      @request = find_request(params[:id])
    end
    
    def activate
      @request = find_request(params[:request_id])
      if @request.activate
        redirect_to [:admin, @request]
      else
        redirect_to [:admin, @request], alert: @request.errors
      end
    end
    
    def decline
      @request = find_request(params[:request_id])
      if @request.decline
        redirect_to [:admin, @request]
      else
        redirect_to [:admin, @request], alert: @request.errors
      end
    end
    
    def finish
      @request = find_request(params[:request_id])
      if @request.finish
        redirect_to [:admin, @request]
      else
        redirect_to [:admin, @request], alert: @request.errors
      end
    end
    
  private
    
    def find_request(id)
      Request.find(id)
    end
  end
end
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
    
    def find_request(id)
      Request.find(id)
    end
    
    def redirect_to_request(request)
      redirect_to [:admin, request]
    end
    
    def redirect_to_request_with_alert(request)
      redirect_to [:admin, request], alert: request.errors
    end
  end
end
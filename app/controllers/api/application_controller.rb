class Api::ApplicationController < ApplicationController
  before_filter :authorize_api!
  skip_before_action :verify_authenticity_token
  respond_to :json
  
  def authorize_api!
    if request.headers["X-Octoshell-Auth"] != Settings.api_token
      render nothing: true, status: 401
    end
  end
end

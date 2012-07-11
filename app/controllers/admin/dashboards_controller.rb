module Admin
  class DashboardsController < BaseController
    def show
      @requests = Request.last_pending
    end
  end
end
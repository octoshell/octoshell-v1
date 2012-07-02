class DashboardsController < ApplicationController
  before_filter :authenticate!
  
  def show
    render nothing: true
  end
end

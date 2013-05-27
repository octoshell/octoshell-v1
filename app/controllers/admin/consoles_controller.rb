class Admin::ConsolesController < Admin::ApplicationController
  before_filter { authorize! :access, :console }
  
  def show
  end
  
  private
  def default_breadcrumb
    false
  end
end

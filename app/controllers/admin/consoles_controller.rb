class Admin::ConsolesController < Admin::ApplicationController
  before_filter { authorize! :access, :console }
  
  def show
  end
end

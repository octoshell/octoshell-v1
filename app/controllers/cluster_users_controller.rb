class ClusterUsersController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = ClusterUser.search(params[:search])
    @clusters = @search.page(params[:page])
  end
  
  def show
    @cluster_user = ClusterUser.find(params[:id])
    authorize! :show, @cluster_user
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

class ClusterUsersController < ApplicationController
  before_filter :setup_default_filter, only: :index
  before_filter :authorize_access_to_controller
  
  def index
    @search = ClusterUser.search(params[:search])
  end
  
  def show
    @cluster_user = ClusterUser.find(params[:id])
  end
  
  def new
    @cluster_user = ClusterUser.new
  end
  
  def create
    @cluster_user = ClusterUser.new(params[:cluster_user], as_role)
    if @cluster_user.save
      redirect_to @cluster_user
    else
      render :new
    end
  end
  
  def edit
    @cluster_user = ClusterUser.find(params[:id])
  end
  
  def update
    @cluster_user = ClusterUser.find(params[:id])
    if @cluster_user.update_attributes(params[:cluster_user], as_role)
      redirect_to @cluster_user
    else
      render :edit
    end
  end
  
private
  
  def namespace
    :admin
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

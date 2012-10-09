class ClusterUsersController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = ClusterUser.search(params[:search])
    @cluster_users = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @cluster_user = ClusterUser.find(params[:id])
    authorize! :show, @cluster_user
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
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

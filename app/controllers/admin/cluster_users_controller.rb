class Admin::ClusterUsersController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  before_filter { authorize! :manage, :cluster_users }
  
  def index
    @search = ClusterUser.search(params[:search])
    @cluster_users = @search.page(params[:page])
  end
  
  def show
    @cluster_user = ClusterUser.find(params[:id])
  end
  
  def new
    @cluster_user = ClusterUser.new
  end
  
  def create
    @cluster_user = ClusterUser.new(params[:cluster_user])
    if @cluster_user.save
      redirect_to [:admin, @cluster_user]
    else
      render :new
    end
  end
  
  def edit
    @cluster_user = ClusterUser.find(params[:id])
  end
  
  def update
    @cluster_user = ClusterUser.find(params[:id])
    if @cluster_user.update_attributes(params[:cluster_user])
      redirect_to [:admin, @cluster_user]
    else
      render :edit
    end
  end
  
private
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

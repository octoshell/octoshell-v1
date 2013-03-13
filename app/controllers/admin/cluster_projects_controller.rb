class Admin::ClusterProjectsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  before_filter { authorize! :manage, :cluster_projects }
  
  def index
    @search = ClusterProject.search(params[:q])
    @cluster_projects = show_all? ? @search.all : @search.result(distinct: true).page(params[:page])
  end
  
  def show
    @cluster_project = ClusterProject.find(params[:id])
  end
  
  def new
    @cluster_project = ClusterProject.new
  end
  
  def create
    @cluster_project = ClusterProject.new(params[:cluster_project])
    if @cluster_project.save
      redirect_to @cluster_project
    else
      render :new
    end
  end
  
  def edit
    @cluster_project = ClusterProject.find(params[:id])
  end
  
  def update
    @cluster_project = ClusterProject.find(params[:id])
    if @cluster_project.update_attributes(params[:cluster_project])
      redirect_to @cluster_project
    else
      render :edit
    end
  end
  
private
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end

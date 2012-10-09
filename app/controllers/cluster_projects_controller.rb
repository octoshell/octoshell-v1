class ClusterProjectsController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = ClusterProject.search(params[:search])
    @cluster_projects = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @cluster_project = ClusterProject.find(params[:id])
  end
  
  def new
    @cluster_project = ClusterProject.new
  end
  
  def create
    @cluster_project = ClusterProject.new(params[:cluster_project], as_role)
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
    if @cluster_project.update_attributes(params[:cluster_project], as_role)
      redirect_to @cluster_project
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

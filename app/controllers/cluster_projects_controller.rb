class ClusterProjectsController < ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = ClusterProject.search(params[:search])
    @cluster_projects = @search.page(params[:page])
  end
  
  def show
    @cluster_project = ClusterProject.find(params[:id])
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

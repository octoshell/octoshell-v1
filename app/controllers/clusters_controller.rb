class ClustersController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Cluster.search(params[:search])
    @clusters = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @cluster = find_cluster(params[:id])
  end
    
private
  
  def find_cluster(id)
    Cluster.find(id)
  end
  
  def namespace
    :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end

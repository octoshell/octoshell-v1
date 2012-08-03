class ClustersController < ApplicationController
  before_filter :require_login
  
  def index
    @clusters = Cluster.all
  end
  
  def show
    @cluster = find_cluster(params[:id])
  end
  
  def new
    @cluster = Cluster.new
  end
  
  def create
    @cluster = Cluster.new(params[:cluster], as_role)
    if @cluster.save
      redirect_to_cluster(@cluster)
    else
      render :new
    end
  end
  
  def edit
    @cluster = find_cluster(params[:id])
  end
  
  def update
    @cluster = find_cluster(params[:id])
    if @cluster.update_attributes(params[:cluster], as_role)
      redirect_to_cluster(@cluster)
    else
      render :edit
    end
  end
  
  def close
    @cluster = find_cluster(params[:id])
    if @cluster.close
      redirect_to @cluster
    else
      redirect_to @cluster, alert: @cluster.errors.full_messages.join(', ')
    end
  end
  
private
  
  def redirect_to_cluster(cluster)
    redirect_to cluster
  end
  
  def redirect_to_index
    redirect_to clusters_path
  end
  
  def find_cluster(id)
    Cluster.find(id)
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
end

class Admin::ClustersController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  before_filter { authorize! :manage, :clusters }
  
  def index
    @search = Cluster.search(params[:q])
    @clusters = show_all? ? @search.all : @search.result(distinct: true).page(params[:page])
  end
  
  def show
    @cluster = find_cluster(params[:id])
  end
  
  def new
    @cluster = Cluster.new
  end
  
  def create
    @cluster = Cluster.new(params[:cluster], as: :admin)
    if @cluster.save
      redirect_to_cluster(@cluster)
    else
      render :new
    end
  end
  
  def edit
    @cluster = find_cluster(params[:id])
    @cluster_fields = @cluster.cluster_fields.to_a
    @cluster_field = @cluster.cluster_fields.build
  end
  
  def update
    @cluster = find_cluster(params[:id])
    if @cluster.update_attributes(params[:cluster], as: :admin)
      redirect_to_cluster(@cluster)
    else
      render :edit
    end
  end
  
  def close
    @cluster = find_cluster(params[:cluster_id])
    if @cluster.close
      redirect_to @cluster
    else
      redirect_to @cluster, alert: @cluster.errors.full_messages.join(', ')
    end
  end
  
  def closed
    @clusters = Cluster.closed
  end
  
private
  
  def redirect_to_cluster(cluster)
    redirect_to [:admin, cluster]
  end
  
  def redirect_to_index
    redirect_to admin_clusters_path
  end
  
  def find_cluster(id)
    Cluster.find(id)
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end

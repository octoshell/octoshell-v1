module Admin
  class ClustersController < BaseController
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
      @cluster = Cluster.new(params[:cluster])
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
      if @cluster.update_attributes(params[:cluster])
        redirect_to_cluster(@cluster)
      else
        render :edit
      end
    end
    
    def destroy
      @cluster = find_cluster(params[:id])
      @cluster.destroy
      redirect_to_index
    end
    
  private
    
    def redirect_to_cluster(cluster)
      redirect_to [:admin, cluster]
    end
    
    def redirect_to_index
      redirect_to [:admin, :clusters]
    end
    
    def find_cluster(id)
      Cluster.find(id)
    end
  end
end

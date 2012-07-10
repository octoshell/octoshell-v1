class ClustersController < ApplicationController
  before_filter :require_login
  
  def show
    @cluster = Cluster.find(params[:id])
  end
end

class ClusterUsersController < ApplicationController
  def show
    @cluster_user = ClusterUser.find(params[:id])
  end
  
private
  
  def namespace
    :admin
  end
end

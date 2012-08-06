class ClusterUsersController < ApplicationController
  def show
    @cluster_user = ClusterUser.find(params[:id])
    authorize! :show, @cluster_user
  end
  
private
  
  def namespace
    :admin
  end
end

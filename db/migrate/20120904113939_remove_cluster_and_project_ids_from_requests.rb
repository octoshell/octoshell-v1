class RemoveClusterAndProjectIdsFromRequests < ActiveRecord::Migration
  def change
    remove_column :cluster_projects, :cluster_user_id
    remove_column :requests, :cluster_id
    remove_column :requests, :project_id
  end
end

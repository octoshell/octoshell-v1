class AddClusterProjectIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :cluster_project_id, :integer
  end
end

class AddClusterIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :cluster_id, :integer
    add_index :requests, :cluster_id
  end
end

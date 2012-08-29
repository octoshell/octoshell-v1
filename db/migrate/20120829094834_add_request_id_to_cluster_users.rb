class AddRequestIdToClusterUsers < ActiveRecord::Migration
  def change
    add_column :cluster_users, :request_id, :integer
    add_index :cluster_users, :request_id
  end
end

class FixUniquenessPendingRequests < ActiveRecord::Migration
  def change
    remove_index :requests, name: :unique_active_request_idx
    ActiveRecord::Base.connection.execute %{
      CREATE UNIQUE INDEX unique_pending_request_idx ON requests (project_id, cluster_id) where state in ('pending', 'active');
    }
  end
end

class RequestsIndexes < ActiveRecord::Migration
  def change
    remove_index :requests, name: :unique_pending_request_idx
    
    ActiveRecord::Base.connection.execute %{
      CREATE UNIQUE INDEX unique_pending_request_idx ON
        requests (project_id, cluster_id)
      WHERE (state in ('pending', 'active'));
    }
  end
end

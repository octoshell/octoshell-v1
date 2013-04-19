class AddUniqueIndexForActiveRequests < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute %{
      CREATE UNIQUE INDEX unique_active_request_idx ON requests (project_id, cluster_id) where state = 'active';
    }
  end
end

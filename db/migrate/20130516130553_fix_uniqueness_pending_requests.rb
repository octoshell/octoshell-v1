class FixUniquenessPendingRequests < ActiveRecord::Migration
  def change
    remove_index :requests, name: :unique_active_request_idx
  end
end

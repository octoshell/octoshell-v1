class MoveMaintainRequestedAtFromProjectsToRequests < ActiveRecord::Migration
  def change
    remove_column :projects, :maintain_requested_at
    add_column :requests, :maintain_requested_at, :datetime
  end
end

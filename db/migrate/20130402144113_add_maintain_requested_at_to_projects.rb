class AddMaintainRequestedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :maintain_requested_at, :datetime
  end
end

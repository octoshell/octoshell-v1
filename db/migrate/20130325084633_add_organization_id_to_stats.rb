class AddOrganizationIdToStats < ActiveRecord::Migration
  def change
    add_column :stats, :organization_id, :integer
  end
end

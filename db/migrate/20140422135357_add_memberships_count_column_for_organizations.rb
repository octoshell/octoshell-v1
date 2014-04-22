class AddMembershipsCountColumnForOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :active_memberships_count, :integer, default: 0
  end
end

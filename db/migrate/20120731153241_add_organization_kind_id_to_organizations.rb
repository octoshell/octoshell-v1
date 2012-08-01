class AddOrganizationKindIdToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :organization_kind_id, :string
    remove_column :organizations, :kind
  end
  
  def down
    remove_column :organizations, :organization_kind_id
    add_column :organizations, :kind, :string
  end
end

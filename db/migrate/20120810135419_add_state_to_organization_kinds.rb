class AddStateToOrganizationKinds < ActiveRecord::Migration
  def change
    add_column :organization_kinds, :state, :string
  end
end

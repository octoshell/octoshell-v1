class RemoveAbbreviationFromOrganizationKinds < ActiveRecord::Migration
  def up
    remove_column :organization_kinds, :abbreviation
  end

  def down
    add_column :organization_kinds, :abbreviation, :string
  end
end

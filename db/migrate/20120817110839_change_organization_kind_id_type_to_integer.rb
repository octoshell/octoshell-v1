class ChangeOrganizationKindIdTypeToInteger < ActiveRecord::Migration
  def up
    change_table :organizations do |t|
      t.remove :organization_kind_id
      t.column :organization_kind_id, :integer
    end
  end

  def down
  end
end

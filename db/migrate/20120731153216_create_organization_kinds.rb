class CreateOrganizationKinds < ActiveRecord::Migration
  def change
    create_table :organization_kinds do |t|
      t.string :name
      t.string :abbreviation
      t.timestamps
    end
  end
end

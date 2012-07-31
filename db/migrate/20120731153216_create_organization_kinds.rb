class CreateOrganizationKinds < ActiveRecord::Migration
  def change
    create_table :organization_kinds do |t|

      t.timestamps
    end
  end
end

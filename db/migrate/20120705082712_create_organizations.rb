class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :kind
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end

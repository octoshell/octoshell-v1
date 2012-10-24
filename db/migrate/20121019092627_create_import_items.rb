class CreateImportItems < ActiveRecord::Migration
  def change
    create_table :import_items do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.string :organization_name
      t.string :project_name
      t.string :group
      t.string :login
      t.text   :keys
      t.timestamps
    end
  end
end

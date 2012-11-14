class AddPhoneToImportItems < ActiveRecord::Migration
  def change
    add_column :import_items, :phone, :string
  end
end

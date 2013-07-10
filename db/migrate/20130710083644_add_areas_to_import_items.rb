class AddAreasToImportItems < ActiveRecord::Migration
  def change
    add_column :import_items, :areas, :text
  end
end

class AddDirectionOfScienceAndCriticalTechnologiesToImportItems < ActiveRecord::Migration
  def change
  	add_column :import_items, :technologies, :text
  	add_column :import_items, :directions, :text
  end
end

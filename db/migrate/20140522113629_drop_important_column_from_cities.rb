class DropImportantColumnFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :important
  end
end

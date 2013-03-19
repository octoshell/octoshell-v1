class AddStrictCollectionToSuretyFields < ActiveRecord::Migration
  def change
    add_column :survey_fields, :strict_collection, :boolean, default: false
  end
end

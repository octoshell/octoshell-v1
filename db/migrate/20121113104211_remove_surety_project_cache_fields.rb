class RemoveSuretyProjectCacheFields < ActiveRecord::Migration
  def change
    remove_column :sureties, :project_name
    remove_column :sureties, :project_description
  end
end

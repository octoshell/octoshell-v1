class AddProjectIdToSureties < ActiveRecord::Migration
  def change
    add_column :sureties, :project_id, :integer
    add_index :sureties, :project_id
  end
end

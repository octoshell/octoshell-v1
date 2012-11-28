class AddPrefixIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_prefix_id, :integer
  end
end

class ReworkClusterProjects < ActiveRecord::Migration
  def change
    change_table :cluster_projects do |t|
      t.integer :project_id
      t.integer :cluster_id
    end
  end
end

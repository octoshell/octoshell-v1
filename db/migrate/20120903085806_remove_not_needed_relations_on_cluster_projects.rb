class RemoveNotNeededRelationsOnClusterProjects < ActiveRecord::Migration
  def change
    change_table :cluster_projects do |t|
      t.remove :project_id
      t.remove :cluster_id
    end
  end
end

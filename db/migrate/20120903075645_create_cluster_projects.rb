class CreateClusterProjects < ActiveRecord::Migration
  def change
    create_table :cluster_projects do |t|
      t.string :state
      t.references :cluster_user
      t.references :cluster
      t.references :project
    end
    
    change_table :cluster_users do |t|
      t.integer :account_id
      t.integer :cluster_project_id
      t.remove :project_id
      t.remove :cluster_id
      t.remove :request_id
    end
  end
end

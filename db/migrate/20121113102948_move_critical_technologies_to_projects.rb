class MoveCriticalTechnologiesToProjects < ActiveRecord::Migration
  def change
    drop_table :critical_technologies_sureties
    
    create_table :critical_technologies_projects, id: false do |t|
      t.integer :critical_technology_id
      t.integer :project_id
    end
    
    add_index :critical_technologies_projects, [:critical_technology_id, :project_id], unique: true, name: 'uniq'
  end
end

class CreateProjectsOrganizations < ActiveRecord::Migration
  def up
    create_table :organizations_projects, id: false do |t|
      t.integer :organization_id
      t.integer :project_id
    end
    
    add_index :organizations_projects, :organization_id
    add_index :organizations_projects, :project_id
    add_index :organizations_projects, [:project_id, :organization_id], unique: true
  end

  def down
    drop_table :organizations_projects
  end
end

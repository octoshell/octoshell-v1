class CreateResearchAreasProjects < ActiveRecord::Migration
  def create
    create_table :research_areas_projects, id: false do |t|
      t.integer :research_area_id
      t.integer :project_id
    end
    
    add_index :research_areas_projects, :project_id
    add_index :research_areas_projects, :research_area_id
    add_index :research_areas_projects, [:project_id, :research_area_id], unique: true
  end
end

class CreateResearchAreasProjects < ActiveRecord::Migration
  def create
    create_table :projects_research_areas, id: false do |t|
      t.integer :research_area_id
      t.integer :project_id
    end
    
    add_index :projects_research_areas, :project_id
    add_index :projects_research_areas, :research_area_id
    add_index :projects_research_areas, [:project_id, :research_area_id], unique: true
  end
end

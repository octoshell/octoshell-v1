class CreateProjectsResearchAreas < ActiveRecord::Migration
  def change
    create_table :projects_research_areas, id: false do |t|
      t.integer :project_id
      t.integer :research_area_id
    end
    
    add_index :projects_research_areas, [:project_id, :research_area_id], unique: true, name: :unqiue_projects_research_areas
    add_index :projects_research_areas, :project_id
    add_index :projects_research_areas, :research_area_id
  end
end

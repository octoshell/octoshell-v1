class CreateProjectsDirectionOfSciences < ActiveRecord::Migration
  def change
    create_table :direction_of_sciences_projects, id: false do |t|
      t.integer :direction_of_science_id
      t.integer :project_id
    end
    add_index :direction_of_sciences_projects, :direction_of_science_id
    add_index :direction_of_sciences_projects, :project_id
    add_index :direction_of_sciences_projects, [:direction_of_science_id, :project_id], unique: true, name: 'uniq_dir_proj'
  end
end

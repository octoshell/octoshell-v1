class RemoveDirectionOfScienceIdFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :direction_of_science_id
  end

  def down
    add_column :projects, :direction_of_science_id, :integer
  end
end

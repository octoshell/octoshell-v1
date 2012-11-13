class MoveDirectionOfScienceToProjects < ActiveRecord::Migration
  def change
    remove_column :sureties, :direction_of_science_id
    add_column :projects, :direction_of_science_id, :integer
    add_index :projects, :direction_of_science_id
  end
end

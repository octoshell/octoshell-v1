class RemovePrefixFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :prefix
  end

  def down
    add_column :projects, :prefix, :string
  end
end

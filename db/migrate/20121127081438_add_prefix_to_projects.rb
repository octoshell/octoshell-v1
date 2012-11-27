class AddPrefixToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :prefix, :string
  end
end

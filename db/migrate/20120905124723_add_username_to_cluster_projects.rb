class AddUsernameToClusterProjects < ActiveRecord::Migration
  def change
    add_column :cluster_projects, :username, :string
  end
end

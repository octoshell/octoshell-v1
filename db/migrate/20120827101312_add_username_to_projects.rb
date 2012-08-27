class AddUsernameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :username, :string
  end
end

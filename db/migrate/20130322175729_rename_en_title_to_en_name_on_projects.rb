class RenameEnTitleToEnNameOnProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :en_title, :en_name
  end
end

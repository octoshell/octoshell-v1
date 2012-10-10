class AddActiveProjectsCountToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :active_projects_count, :integer, default: 0
  end
end

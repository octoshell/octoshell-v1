class RemovePublicationsCountFromReportProjects < ActiveRecord::Migration
  def up
    remove_column :report_projects, :publications_count
  end

  def down
    add_column :report_projects, :publications_count, :integer
  end
end

class AddInternationalConferencesInRussiaToReportProjects < ActiveRecord::Migration
  def change
    add_column :report_projects, :international_conferences_in_russia_count, :integer, default: 0
  end
end

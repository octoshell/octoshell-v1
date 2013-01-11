class AddOrganizationIdToReportOrganizations < ActiveRecord::Migration
  def change
    add_column :report_organizations, :organization_id, :integer
  end
end

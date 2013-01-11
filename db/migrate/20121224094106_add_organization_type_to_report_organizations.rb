class AddOrganizationTypeToReportOrganizations < ActiveRecord::Migration
  def change
    add_column :report_organizations, :organization_type, :string
  end
end

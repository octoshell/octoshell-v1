class AddOtherPositionToReportOrganizations < ActiveRecord::Migration
  def change
    add_column :report_organizations, :other_position, :string
  end
end

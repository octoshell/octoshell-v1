class CreateReportOrganizations < ActiveRecord::Migration
  def change
    create_table :report_organizations do |t|
      t.references :report
      t.string :name
      t.string :subdivision
      t.string :position
    end
  end
end

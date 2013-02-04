class AddSubmittedAtToReports < ActiveRecord::Migration
  def change
    add_column :reports, :submitted_at, :datetime
  end
end

class AddReasonToReportPersonalData < ActiveRecord::Migration
  def change
    add_column :report_personal_data, :reason, :text
  end
end

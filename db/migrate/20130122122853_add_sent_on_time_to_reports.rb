class AddSentOnTimeToReports < ActiveRecord::Migration
  def change
    add_column :reports, :sent_on_time, :boolean, default: false
  end
end

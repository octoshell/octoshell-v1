class DropReportRequests < ActiveRecord::Migration
  def change
    drop_table :report_requests
  end
end

class AddReportIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :report_id, :integer
    add_index :tickets, :report_id
  end
end

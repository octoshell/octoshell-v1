class CreateReportRequests < ActiveRecord::Migration
  def change
    create_table :report_requests do |t|
      t.references :report
      t.string :hours
      t.string :size
      t.string :full_power
      t.string :strict_schedule
      t.string :comment
    end
  end
end

class AddPeriodToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :start_at, :datetime
    add_column :notices, :end_at, :datetime
    add_index :notices, [:start_at, :end_at]
  end
end

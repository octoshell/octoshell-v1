class AddReceivingToToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :receiving_to, :date
  end
end

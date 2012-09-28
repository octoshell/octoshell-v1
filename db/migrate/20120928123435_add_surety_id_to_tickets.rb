class AddSuretyIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :surety_id, :integer
    add_index :tickets, :surety_id
  end
end

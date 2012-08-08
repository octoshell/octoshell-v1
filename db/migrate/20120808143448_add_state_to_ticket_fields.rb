class AddStateToTicketFields < ActiveRecord::Migration
  def change
    add_column :ticket_fields, :state, :string
  end
end

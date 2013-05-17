class SetTicketFieldValueToText < ActiveRecord::Migration
  def change
    change_column :ticket_field_values, :value, :text
  end
end

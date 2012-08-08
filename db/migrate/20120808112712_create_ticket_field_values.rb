class CreateTicketFieldValues < ActiveRecord::Migration
  def change
    create_table :ticket_field_values do |t|
      t.string :value
      t.references :ticket_field_relation
      t.references :ticket
      t.timestamps
    end
  end
end

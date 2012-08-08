class CreateAdditionalTicketFieldValues < ActiveRecord::Migration
  def change
    create_table :additional_ticket_field_values do |t|
      t.string :value
      t.integer :additional_ticket_field_id
      t.integer :ticket_id
      t.timestamps
    end
  end
end

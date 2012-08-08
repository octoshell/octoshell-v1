class CreateTicketFields < ActiveRecord::Migration
  def change
    create_table :ticket_fields do |t|
      t.string :name
      t.string :hint
      t.timestamps
    end
  end
end

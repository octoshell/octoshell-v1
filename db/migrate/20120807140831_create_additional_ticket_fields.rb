class CreateAdditionalTicketFields < ActiveRecord::Migration
  def change
    create_table :additional_ticket_fields do |t|
      t.string :name
      t.string :hint
      t.boolean :required, default: false
      t.timestamps
    end
  end
end

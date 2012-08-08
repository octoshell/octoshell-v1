class CreateTicketFieldRelations < ActiveRecord::Migration
  def change
    create_table :ticket_field_relations do |t|
      t.references :ticket_question
      t.references :ticket_field
      t.boolean :required, default: false
      t.timestamps
    end
  end
end

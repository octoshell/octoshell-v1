class CreateTicketTagRelations < ActiveRecord::Migration
  def change
    create_table :ticket_tag_relations do |t|
      t.integer :ticket_id
      t.integer :ticket_tag_id
      t.boolean :active, default: false
      t.timestamps
    end
  end
end

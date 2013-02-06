class AddUniqueIndexOnTicketTagRelations < ActiveRecord::Migration
  def change
    add_index :ticket_tag_relations, [:ticket_id, :ticket_tag_id], unique: true
  end
end

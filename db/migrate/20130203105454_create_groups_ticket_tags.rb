class CreateGroupsTicketTags < ActiveRecord::Migration
  def change
    create_table :groups_ticket_tags, id: false do |t|
      t.integer :group_id
      t.integer :ticket_tag_id
    end
    
    add_index :groups_ticket_tags, [:ticket_tag_id, :group_id], unique: true
    add_index :groups_ticket_tags, :ticket_tag_id
    add_index :groups_ticket_tags, :group_id
  end
end

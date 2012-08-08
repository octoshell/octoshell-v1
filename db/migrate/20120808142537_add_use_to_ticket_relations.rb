class AddUseToTicketRelations < ActiveRecord::Migration
  def change
    add_column :ticket_field_relations, :use, :boolean, default: false
  end
end

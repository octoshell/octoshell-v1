class AddStateToTicketTags < ActiveRecord::Migration
  def change
    add_column :ticket_tags, :state, :string
  end
end

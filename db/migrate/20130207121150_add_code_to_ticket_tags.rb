class AddCodeToTicketTags < ActiveRecord::Migration
  def change
    add_column :ticket_tags, :code, :string
  end
end

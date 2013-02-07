class AddSystemToTicketTags < ActiveRecord::Migration
  def change
    add_column :ticket_tags, :system, :boolean, default: false
  end
end

class AddUrlToTicketFields < ActiveRecord::Migration
  def change
    add_column :ticket_fields, :url, :boolean, default: false
  end
end

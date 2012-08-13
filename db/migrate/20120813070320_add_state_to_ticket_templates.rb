class AddStateToTicketTemplates < ActiveRecord::Migration
  def change
    add_column :ticket_templates, :state, :string
  end
end

class RenameTemplatesToTicketTemplates < ActiveRecord::Migration
  def up
    rename_table :templates, :ticket_templates
  end

  def down
    rename_table :ticket_templates, :templates
  end
end

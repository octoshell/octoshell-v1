class CreateTicketTags < ActiveRecord::Migration
  def change
    create_table :ticket_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end

class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :message
      t.references :user
      t.string :state
      t.string :url
      t.timestamps
    end
  end
end

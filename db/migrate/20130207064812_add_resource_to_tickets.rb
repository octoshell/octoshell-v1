class AddResourceToTickets < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.integer :resource_id
      t.string :resource_class
      t.index [:resource_class, :resource_id]
    end
  end
end

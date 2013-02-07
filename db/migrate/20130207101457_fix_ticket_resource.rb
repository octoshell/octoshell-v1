class FixTicketResource < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.remove :resource_class
      t.string :resource_type
      t.index [:resource_type, :resource_id]
    end
  end
end

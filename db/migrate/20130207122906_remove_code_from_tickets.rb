class RemoveCodeFromTickets < ActiveRecord::Migration
  def up
    remove_column :tickets, :code
  end

  def down
    add_column :tickets, :code, :string
  end
end

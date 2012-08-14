class AddClusterIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :cluster_id, :integer
  end
end

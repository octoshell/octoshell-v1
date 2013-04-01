class RenewRequests < ActiveRecord::Migration
  def change
    change_table :requests do |t|
      t.integer :project_id
    end
    
    add_index :requests, :project_id
  end
end

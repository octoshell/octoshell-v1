class CreateNewReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :session_id
      t.integer :project_id
      t.string :state
      t.attachment :materials
    end
    
    add_index :reports, :session_id
    add_index :reports, [:session_id, :state]
    add_index :reports, [:session_id, :project_id], unique: true
  end
end

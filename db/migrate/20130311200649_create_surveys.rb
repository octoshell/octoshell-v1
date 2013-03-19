class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :session_id
    end
    
    add_index :surveys, :session_id
  end
end

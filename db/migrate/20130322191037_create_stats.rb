class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :session_id
      t.integer :survey_field_id
      t.string :group_by
      t.integer :weight, default: 0
    end
    
    add_index :stats, :session_id
  end
end

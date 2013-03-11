class CreateSurveyFields < ActiveRecord::Migration
  def change
    create_table :survey_fields do |t|
      t.integer :survey_id
      t.string :kind
      t.text :collection
      t.text :collection_sql
      t.integer :max_values, default: 1
      t.integer :weight, default: 0
    end
    
    add_index :survey_fields, :survey_id
  end
end

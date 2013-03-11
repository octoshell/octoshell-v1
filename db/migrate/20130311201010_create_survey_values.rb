class CreateSurveyValues < ActiveRecord::Migration
  def change
    create_table :survey_values do |t|
      t.text :value
      t.integer :survey_field_id
      t.integer :user_id
    end
    
    add_index :survey_values, [:survey_field_id, :user_id], unique: true
  end
end

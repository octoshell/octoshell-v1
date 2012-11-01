class AddProjectFieldsToSureties < ActiveRecord::Migration
  def change
    change_table :sureties do |t|
      t.string  :project_description
      t.string  :project_name
      t.integer :direction_of_science_id
      t.integer :critical_technology_id
    end
  end
end

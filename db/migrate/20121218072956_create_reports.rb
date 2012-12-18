class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user
      t.references :project
      t.text :personal_data
      t.text :organizations
      t.text :personal_survey
      t.text :projects
      t.text :request
      t.text :points
      t.timestamps
    end
  end
end

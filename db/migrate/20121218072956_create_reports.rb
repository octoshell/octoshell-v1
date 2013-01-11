class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user
      t.references :project
      t.hstore :points
      t.timestamps
    end
  end
end

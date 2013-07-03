class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.string :kind
      t.text :data
      t.date :date
    end
  end
end

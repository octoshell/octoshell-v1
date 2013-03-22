class AddCardFieldsToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string :en_title
      t.text :driver
      t.text :en_driver
      t.text :strategy
      t.text :en_strategy
      t.text :objective
      t.text :en_objective
      t.text :impact
      t.text :en_impact
      t.text :usage
      t.text :en_usage
    end
  end
end

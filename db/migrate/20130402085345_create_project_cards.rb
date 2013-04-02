class CreateProjectCards < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.rename :name, :title
      t.remove :en_name
      t.remove :driver
      t.remove :en_driver
      t.remove :strategy
      t.remove :en_strategy
      t.remove :objective
      t.remove :en_objective
      t.remove :impact
      t.remove :en_impact
      t.remove :usage
      t.remove :en_usage
    end
    
    create_table :project_cards do |t|
      t.integer :project_id
      t.text :name
      t.text :en_name
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
    
    add_index :project_cards, :project_id
  end
end

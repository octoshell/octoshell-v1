class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :stdin
      t.text :stderr
      t.text :stdout
      t.string :state
      t.string :resource_type
      t.integer :resource_id
      t.timestamps
    end
  end
end

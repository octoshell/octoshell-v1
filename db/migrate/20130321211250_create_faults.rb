class CreateFaults < ActiveRecord::Migration
  def change
    create_table :faults do |t|
      t.integer :user_id
      t.text :description
      t.references :reference
      t.string :state
      t.timestamps
    end
  end
end

class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.references :membership
      t.string :name
      t.string :value
      t.timestamps
    end
  end
end

class CreatePositionNames < ActiveRecord::Migration
  def change
    create_table :position_names do |t|
      t.string :name
      t.timestamps
    end
  end
end

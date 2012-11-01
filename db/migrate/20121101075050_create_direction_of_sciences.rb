class CreateDirectionOfSciences < ActiveRecord::Migration
  def change
    create_table :direction_of_sciences do |t|
      t.string :name

      t.timestamps
    end
  end
end

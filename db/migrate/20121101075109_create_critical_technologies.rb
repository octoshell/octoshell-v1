class CreateCriticalTechnologies < ActiveRecord::Migration
  def change
    create_table :critical_technologies do |t|
      t.string :name

      t.timestamps
    end
  end
end

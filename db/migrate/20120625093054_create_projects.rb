class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end

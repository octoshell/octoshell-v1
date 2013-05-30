class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :body
      t.string :state
      t.timestamps
    end
  end
end

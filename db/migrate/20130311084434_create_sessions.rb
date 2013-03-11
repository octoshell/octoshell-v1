class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.date :start_at
      t.date :end_at
    end
  end
end

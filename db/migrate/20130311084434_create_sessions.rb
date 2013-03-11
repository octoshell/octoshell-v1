class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :state
      t.timestamp :started_at
      t.timestamp :ended_at
    end
  end
end

class RebuildSessions < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.remove :start_at
      t.remove :end_at
      t.timestamp :started_at
      t.timestamp :ended_at
      t.string :description
    end
  end
end

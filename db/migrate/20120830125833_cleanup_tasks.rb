class CleanupTasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.remove "command"
      t.remove "stderr"
      t.remove "stdout"
      t.remove "state"
      t.remove "data"
      t.remove "event"
    end
  end
end

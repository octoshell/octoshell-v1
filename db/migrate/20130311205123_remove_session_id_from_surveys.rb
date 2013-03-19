class RemoveSessionIdFromSurveys < ActiveRecord::Migration
  def up
    remove_column :surveys, :session_id
  end

  def down
    add_column :surveys, :session_id, :integer
  end
end

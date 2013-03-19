class AddMotivationToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :motivation, :string
  end
end

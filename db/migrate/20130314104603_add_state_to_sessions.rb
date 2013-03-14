class AddStateToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :state, :string
  end
end

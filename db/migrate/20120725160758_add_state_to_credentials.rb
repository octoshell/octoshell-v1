class AddStateToCredentials < ActiveRecord::Migration
  def change
    add_column :credentials, :state, :string
  end
end

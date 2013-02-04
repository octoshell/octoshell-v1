class AddAllowStateToReports < ActiveRecord::Migration
  def change
    add_column :reports, :allow_state, :string
  end
end

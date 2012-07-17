class AddProcedureAndDataToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :procedure, :string
    add_column :tasks, :data, :text
  end
end

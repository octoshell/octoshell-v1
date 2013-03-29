class AddKindToFaults < ActiveRecord::Migration
  def change
    add_column :faults, :kind, :string
  end
end

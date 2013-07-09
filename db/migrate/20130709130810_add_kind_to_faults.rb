class AddKindToFaults < ActiveRecord::Migration
  def change
    add_column :faults, :kind_of_block, :string
    Fault.update_all kind_of_block: "user"
  end
end

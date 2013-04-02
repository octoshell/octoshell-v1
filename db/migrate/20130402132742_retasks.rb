class Retasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.remove :procedure
      t.remove :comment
      t.remove :callbacks_performed
    end
  end
end

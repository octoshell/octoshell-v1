class CreateExtends < ActiveRecord::Migration
  def change
    create_table :extends do |t|
      t.string :url
      t.string :script
    end
  end
end

class CreateClusterUsers < ActiveRecord::Migration
  def change
    create_table :cluster_users do |t|
      t.integer :project_id
      t.string :state
      t.integer :cluster_id

      t.timestamps
    end
  end
end

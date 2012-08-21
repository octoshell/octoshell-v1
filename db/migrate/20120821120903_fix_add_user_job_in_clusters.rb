class FixAddUserJobInClusters < ActiveRecord::Migration
  def up
    change_table :clusters do |t|
      t.change_default :add_user, "user=%user%\nhost=%host%"
    end
  end

  def down
  end
end

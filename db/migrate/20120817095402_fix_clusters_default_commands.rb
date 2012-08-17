class FixClustersDefaultCommands < ActiveRecord::Migration
  def up
    change_table :clusters do |f|
      f.change_default :add_user, "user=%user\n%host=%host%"
    end
  end

  def down
  end
end

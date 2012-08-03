class AddCommandsToClusters < ActiveRecord::Migration
  def up
    user = ['user=%user%', 'host=%host%'].join("\n")
    openkey = [user, 'public_key=%public_key%'].join("\n")
    change_table :clusters do |t|
      t.text :add_user,     default: user
      t.text :del_user,     default: user
      t.text :add_openkey,  default: openkey
      t.text :del_openkey,  default: openkey
      t.text :block_user,   default: user
      t.text :unblock_user, default: user
    end
  end
  
  def down
    change_table :clusters do |t|
      t.remove :add_user
      t.remove :del_user
      t.remove :add_openkey
      t.remove :del_openkey
      t.remove :block_user
      t.remove :unblock_user
    end
  end
end

class AddAccountNamesToClusterProcedures < ActiveRecord::Migration
  def change
    change_table :clusters do |t|
      t.change_default :add_openkey,  "project=%project%\nuser=%user%\nhost=%host%\npublic_key=%public_key%"
      t.change_default :del_openkey,  "project=%project%\nuser=%user%\nhost=%host%\npublic_key=%public_key%"
      t.change_default :add_user,     "project=%project%\nhost=%host%"
      t.change_default :del_user,     "project=%project%\nhost=%host%"
      t.change_default :block_user,   "project=%project%\nhost=%host%"
      t.change_default :unblock_user, "project=%project%\nhost=%host%"
    end
  end
end

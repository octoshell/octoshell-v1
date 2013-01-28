class AddUniqueLowerEmailIndexOnUsers < ActiveRecord::Migration
  def change
    remove_index :users, :email
    execute "create unique index unique_users_with_same_email on users using btree (lower(email))"
  end
end

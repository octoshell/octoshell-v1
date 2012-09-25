class CreateAccountCodes < ActiveRecord::Migration
  def change
    create_table :account_codes do |t|
      t.string :code
      t.integer :project_id
      t.string :email
      t.timestamps
    end
    
    add_index :account_codes, :project_id
  end
end

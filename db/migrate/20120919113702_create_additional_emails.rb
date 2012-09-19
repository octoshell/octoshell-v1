class CreateAdditionalEmails < ActiveRecord::Migration
  def change
    create_table :additional_emails do |t|
      t.string :email
      t.integer :user_id
    end
    
    add_index :additional_emails, :email, unique: true
  end
end

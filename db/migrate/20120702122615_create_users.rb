class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # sorcery core
      t.string :email,            default: nil
      t.string :crypted_password, default: nil
      t.string :salt,             default: nil
      
      # sorcery remember me
      t.string :remember_me_token,              default: nil
      t.datetime :remember_me_token_expires_at, default: nil
      
      # sorcery reset password
      t.string :reset_password_token,              default: nil
      t.datetime :reset_password_token_expires_at, default: nil
      t.datetime :reset_password_email_sent_at,    default: nil
      
      # sorcery user activation
      t.string :activation_state,              default: nil
      t.string :activation_token,              default: nil
      t.datetime :activation_token_expires_at, default: nil
      
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      
      t.timestamp :deleted_at
      t.timestamps
    end
    
    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
    add_index :users, :activation_token
  end
end

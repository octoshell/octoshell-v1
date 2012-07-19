# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120718090150) do

  create_table "accesses", :force => true do |t|
    t.integer  "credential_id"
    t.integer  "cluster_id"
    t.integer  "project_id"
    t.string   "state"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "accesses", ["credential_id", "cluster_id", "project_id"], :name => "index_accesses_on_credential_id_and_cluster_id_and_project_id", :unique => true

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "accounts", ["project_id"], :name => "index_accounts_on_project_id"
  add_index "accounts", ["user_id", "project_id"], :name => "index_accounts_on_user_id_and_project_id", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "clusters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "host"
    t.string   "description"
  end

  create_table "credentials", :force => true do |t|
    t.text     "public_key"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  add_index "credentials", ["public_key", "user_id"], :name => "index_credentials_on_public_key_and_user_id", :unique => true
  add_index "credentials", ["public_key"], :name => "index_credentials_on_public_key"

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "model_type"
    t.integer  "position",   :default => 1
    t.datetime "deleted_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.datetime "deleted_at"
  end

  create_table "position_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "positions", :force => true do |t|
    t.integer  "membership_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.string   "state"
    t.text     "description"
  end

  create_table "requests", :force => true do |t|
    t.integer  "project_id"
    t.integer  "cluster_id"
    t.integer  "hours"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "state"
    t.integer  "size"
    t.string   "comment"
  end

  add_index "requests", ["cluster_id"], :name => "index_requests_on_cluster_id"
  add_index "requests", ["project_id"], :name => "index_requests_on_project_id"

  create_table "sureties", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "comment"
  end

  create_table "tasks", :force => true do |t|
    t.text     "command"
    t.text     "stderr"
    t.text     "stdout"
    t.string   "state"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "procedure"
    t.text     "data"
    t.string   "event"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.datetime "deleted_at"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.boolean  "admin",                           :default => false
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "values", :force => true do |t|
    t.integer  "field_id"
    t.integer  "model_id"
    t.integer  "model_type"
    t.text     "value"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "values", ["field_id", "model_id", "model_type"], :name => "index_values_on_field_id_and_model_id_and_model_type", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end

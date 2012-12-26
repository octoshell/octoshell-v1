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

ActiveRecord::Schema.define(:version => 20121225134636) do

  create_table "abilities", :force => true do |t|
    t.string   "action"
    t.string   "subject"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "group_id"
    t.boolean  "available",  :default => false
  end

  add_index "abilities", ["group_id", "subject", "action"], :name => "index_abilities_on_group_id_and_subject_and_action", :unique => true
  add_index "abilities", ["group_id"], :name => "index_abilities_on_group_id"

  create_table "accesses", :force => true do |t|
    t.integer  "credential_id"
    t.string   "state"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "cluster_user_id"
  end

  add_index "accesses", ["credential_id", "cluster_user_id"], :name => "index_accesses_on_credential_id_and_cluster_user_id", :unique => true
  add_index "accesses", ["credential_id"], :name => "index_accesses_on_credential_id"
  add_index "accesses", ["state"], :name => "index_accesses_on_state"

  create_table "account_codes", :force => true do |t|
    t.string   "code"
    t.integer  "project_id"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
    t.integer  "user_id"
  end

  add_index "account_codes", ["project_id"], :name => "index_account_codes_on_project_id"

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
    t.string   "username"
  end

  add_index "accounts", ["project_id"], :name => "index_accounts_on_project_id"
  add_index "accounts", ["state"], :name => "index_accounts_on_state"
  add_index "accounts", ["user_id", "project_id"], :name => "index_accounts_on_user_id_and_project_id", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "additional_emails", :force => true do |t|
    t.string  "email"
    t.integer "user_id"
  end

  create_table "cluster_fields", :force => true do |t|
    t.integer "cluster_id"
    t.string  "name"
  end

  add_index "cluster_fields", ["cluster_id"], :name => "index_cluster_fields_on_cluster_id"

  create_table "cluster_projects", :force => true do |t|
    t.string  "state"
    t.integer "project_id"
    t.integer "cluster_id"
    t.string  "username"
  end

  add_index "cluster_projects", ["cluster_id", "project_id"], :name => "index_cluster_projects_on_cluster_id_and_project_id", :unique => true

  create_table "cluster_users", :force => true do |t|
    t.string   "state"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "account_id"
    t.integer  "cluster_project_id"
    t.string   "username"
  end

  add_index "cluster_users", ["cluster_project_id", "account_id"], :name => "index_cluster_users_on_cluster_project_id_and_account_id", :unique => true

  create_table "clusters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "host"
    t.string   "description"
    t.string   "state"
    t.text     "statistic"
    t.datetime "statistic_updated_at"
    t.string   "cluster_user_type",    :default => "account"
  end

  add_index "clusters", ["state"], :name => "index_clusters_on_state"

  create_table "credentials", :force => true do |t|
    t.text     "public_key"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "state"
  end

  add_index "credentials", ["public_key"], :name => "index_credentials_on_public_key"
  add_index "credentials", ["user_id", "state"], :name => "index_credentials_on_user_id_and_state"
  add_index "credentials", ["user_id"], :name => "index_credentials_on_user_id"

  create_table "critical_technologies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "critical_technologies_projects", :id => false, :force => true do |t|
    t.integer "critical_technology_id"
    t.integer "project_id"
  end

  add_index "critical_technologies_projects", ["critical_technology_id", "project_id"], :name => "uniq", :unique => true

  create_table "direction_of_sciences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "direction_of_sciences_projects", :id => false, :force => true do |t|
    t.integer "direction_of_science_id"
    t.integer "project_id"
  end

  add_index "direction_of_sciences_projects", ["direction_of_science_id", "project_id"], :name => "uniq_dir_proj", :unique => true
  add_index "direction_of_sciences_projects", ["direction_of_science_id"], :name => "index_direction_of_sciences_projects_on_direction_of_science_id"
  add_index "direction_of_sciences_projects", ["project_id"], :name => "index_direction_of_sciences_projects_on_project_id"

  create_table "expands", :force => true do |t|
    t.string "url"
    t.string "script"
  end

  create_table "extends", :force => true do |t|
    t.string  "url"
    t.string  "script"
    t.string  "header"
    t.string  "footer"
    t.integer "weight", :default => 1
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "model_type"
    t.integer  "position",   :default => 1
    t.datetime "deleted_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "group_abilities", :force => true do |t|
    t.integer "group_id"
    t.integer "ability_id"
    t.boolean "available"
  end

  add_index "group_abilities", ["ability_id"], :name => "index_group_abilities_on_ability_id"
  add_index "group_abilities", ["group_id", "ability_id"], :name => "index_group_abilities_on_group_id_and_ability_id", :unique => true
  add_index "group_abilities", ["group_id"], :name => "index_group_abilities_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.boolean  "system"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "history_items", :force => true do |t|
    t.integer  "user_id"
    t.text     "data"
    t.string   "kind"
    t.datetime "created_at"
    t.integer  "author_id"
  end

  add_index "history_items", ["kind"], :name => "index_history_items_on_kind"
  add_index "history_items", ["user_id"], :name => "index_history_items_on_user_id"

  create_table "import_items", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "organization_name"
    t.string   "project_name"
    t.string   "group"
    t.string   "login"
    t.text     "keys"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "cluster_id"
    t.text     "technologies"
    t.text     "directions"
    t.string   "phone"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "state"
  end

  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "organization_kinds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "organization_kinds", ["state"], :name => "index_organization_kinds_on_state"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.boolean  "approved",              :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "state"
    t.string   "abbreviation"
    t.integer  "organization_kind_id"
    t.integer  "active_projects_count", :default => 0
  end

  add_index "organizations", ["state"], :name => "index_organizations_on_state"

  create_table "organizations_projects", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "project_id"
  end

  add_index "organizations_projects", ["organization_id"], :name => "index_organizations_projects_on_organization_id"
  add_index "organizations_projects", ["project_id", "organization_id"], :name => "index_organizations_projects_on_project_id_and_organization_id", :unique => true
  add_index "organizations_projects", ["project_id"], :name => "index_organizations_projects_on_project_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "locator"
    t.boolean  "publicized", :default => false
  end

  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "position_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "autocomplete"
  end

  create_table "positions", :force => true do |t|
    t.integer  "membership_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "positions", ["membership_id"], :name => "index_positions_on_membership_id"

  create_table "project_prefixes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "user_id"
    t.string   "state"
    t.text     "description"
    t.integer  "organization_id"
    t.string   "cluster_user_type", :default => "account"
    t.string   "username"
    t.integer  "project_prefix_id"
  end

  add_index "projects", ["organization_id"], :name => "index_projects_on_organization_id"
  add_index "projects", ["state"], :name => "index_projects_on_state"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "replies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.text     "message"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "replies", ["ticket_id"], :name => "index_replies_on_ticket_id"
  add_index "replies", ["user_id"], :name => "index_replies_on_user_id"

  create_table "report_organizations", :force => true do |t|
    t.integer "report_id"
    t.string  "name"
    t.string  "subdivision"
    t.string  "position"
    t.string  "organization_type"
  end

  create_table "report_personal_data", :force => true do |t|
    t.integer "report_id"
    t.string  "last_name"
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "email"
    t.string  "phone"
    t.string  "confirm_data"
  end

  create_table "report_personal_surveys", :force => true do |t|
    t.integer "report_id"
    t.text    "software"
    t.text    "technologies"
    t.text    "compilators"
    t.text    "learning"
    t.text    "wanna_be_speaker"
    t.text    "request_technology"
    t.text    "other_technology"
    t.text    "precision"
    t.text    "other_compilator"
    t.text    "other_software"
    t.text    "other_learning"
    t.text    "computing"
    t.text    "comment"
  end

  create_table "report_projects", :force => true do |t|
    t.integer  "report_id"
    t.text     "ru_title"
    t.text     "ru_author"
    t.text     "ru_email"
    t.text     "ru_driver"
    t.text     "ru_strategy"
    t.text     "ru_objective"
    t.text     "ru_impact"
    t.text     "ru_usage"
    t.text     "en_title"
    t.text     "en_author"
    t.text     "en_email"
    t.text     "en_driver"
    t.text     "en_strategy"
    t.text     "en_objective"
    t.text     "en_impact"
    t.text     "en_usage"
    t.text     "directions_of_science"
    t.text     "critical_technologies"
    t.text     "areas"
    t.text     "computing_systems"
    t.text     "lomonosov_logins"
    t.text     "chebyshev_logins"
    t.string   "materials_file_name"
    t.string   "materials_content_type"
    t.integer  "materials_file_size"
    t.datetime "materials_updated_at"
    t.integer  "books_count",                               :default => 0
    t.integer  "vacs_count",                                :default => 0
    t.integer  "lectures_count",                            :default => 0
    t.integer  "international_conferences_count",           :default => 0
    t.integer  "russian_conferences_count",                 :default => 0
    t.integer  "doctors_dissertations_count",               :default => 0
    t.integer  "candidates_dissertations_count",            :default => 0
    t.integer  "students_count",                            :default => 0
    t.integer  "graduates_count",                           :default => 0
    t.integer  "your_students_count",                       :default => 0
    t.integer  "rffi_grants_count",                         :default => 0
    t.integer  "ministry_of_education_grants_count",        :default => 0
    t.integer  "rosnano_grants_count",                      :default => 0
    t.integer  "ministry_of_communications_grants_count",   :default => 0
    t.integer  "ministry_of_defence_grants_count",          :default => 0
    t.integer  "ran_grants_count",                          :default => 0
    t.integer  "other_russian_grants_count",                :default => 0
    t.integer  "other_intenational_grants_count",           :default => 0
    t.text     "award_names"
    t.integer  "lomonosov_intel_hours",                     :default => 0
    t.integer  "lomonosov_nvidia_hours",                    :default => 0
    t.integer  "chebyshev_hours",                           :default => 0
    t.integer  "lomonosov_size",                            :default => 0
    t.integer  "chebyshev_size",                            :default => 0
    t.text     "exclusive_usage"
    t.text     "strict_schedule"
    t.boolean  "wanna_speak"
    t.text     "request_comment"
    t.integer  "international_conferences_in_russia_count", :default => 0
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.hstore   "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "request_properties", :force => true do |t|
    t.string  "name"
    t.string  "value"
    t.integer "request_id"
  end

  add_index "request_properties", ["request_id"], :name => "index_request_properties_on_request_id"

  create_table "requests", :force => true do |t|
    t.integer  "cpu_hours"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "user_id"
    t.string   "state"
    t.integer  "size"
    t.string   "comment"
    t.integer  "cluster_project_id"
    t.integer  "gpu_hours",          :default => 0
  end

  add_index "requests", ["state"], :name => "index_requests_on_state"
  add_index "requests", ["user_id"], :name => "index_requests_on_user_id"

  create_table "role_accesses", :force => true do |t|
    t.string  "action"
    t.string  "controller"
    t.text    "condition"
    t.boolean "all",        :default => false
  end

  create_table "role_name_relations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_name_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "role_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "role_relations", :force => true do |t|
    t.integer "role_access_id"
    t.integer "role_name_id"
  end

  create_table "sureties", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "state"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "comment"
    t.integer  "project_id"
    t.string   "boss_full_name"
    t.string   "boss_position"
    t.integer  "cpu_hours",       :default => 0
    t.integer  "size",            :default => 0
    t.integer  "gpu_hours",       :default => 0
  end

  add_index "sureties", ["organization_id"], :name => "index_sureties_on_organization_id"
  add_index "sureties", ["project_id"], :name => "index_sureties_on_project_id"
  add_index "sureties", ["state"], :name => "index_sureties_on_state"
  add_index "sureties", ["user_id"], :name => "index_sureties_on_user_id"

  create_table "surety_members", :force => true do |t|
    t.integer "surety_id"
    t.integer "user_id"
    t.string  "email"
    t.string  "full_name"
    t.integer "account_code_id"
  end

  add_index "surety_members", ["surety_id", "user_id"], :name => "index_surety_members_on_surety_id_and_user_id", :unique => true
  add_index "surety_members", ["surety_id"], :name => "index_surety_members_on_surety_id"
  add_index "surety_members", ["user_id"], :name => "index_surety_members_on_user_id"

  create_table "tasks", :force => true do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "procedure"
    t.text     "comment"
    t.boolean  "callbacks_performed", :default => false
    t.string   "state"
    t.datetime "runned_at"
  end

  add_index "tasks", ["resource_id", "resource_type"], :name => "index_tasks_on_resource_id_and_resource_type"

  create_table "ticket_field_relations", :force => true do |t|
    t.integer  "ticket_question_id"
    t.integer  "ticket_field_id"
    t.boolean  "required",           :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "use",                :default => false
  end

  add_index "ticket_field_relations", ["ticket_field_id"], :name => "index_ticket_field_relations_on_ticket_field_id"
  add_index "ticket_field_relations", ["ticket_question_id"], :name => "index_ticket_field_relations_on_ticket_question_id"

  create_table "ticket_field_values", :force => true do |t|
    t.string   "value"
    t.integer  "ticket_field_relation_id"
    t.integer  "ticket_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "ticket_field_values", ["ticket_field_relation_id"], :name => "index_ticket_field_values_on_ticket_field_relation_id"
  add_index "ticket_field_values", ["ticket_id"], :name => "index_ticket_field_values_on_ticket_id"

  create_table "ticket_fields", :force => true do |t|
    t.string   "name"
    t.string   "hint"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "ticket_fields", ["state"], :name => "index_ticket_fields_on_state"

  create_table "ticket_questions", :force => true do |t|
    t.integer  "ticket_question_id"
    t.string   "question"
    t.boolean  "leaf",               :default => true
    t.string   "state"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "ticket_questions", ["state"], :name => "index_ticket_questions_on_state"
  add_index "ticket_questions", ["ticket_question_id"], :name => "index_ticket_questions_on_ticket_question_id"

  create_table "ticket_tag_relations", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "ticket_tag_id"
    t.boolean  "active",        :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "ticket_tag_relations", ["ticket_id"], :name => "index_ticket_tag_relations_on_ticket_id"
  add_index "ticket_tag_relations", ["ticket_tag_id"], :name => "index_ticket_tag_relations_on_ticket_tag_id"

  create_table "ticket_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "ticket_tags", ["state"], :name => "index_ticket_tags_on_state"

  create_table "ticket_templates", :force => true do |t|
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
  end

  add_index "ticket_templates", ["state"], :name => "index_ticket_templates_on_state"

  create_table "tickets", :force => true do |t|
    t.string   "subject"
    t.text     "message"
    t.integer  "user_id"
    t.string   "state"
    t.string   "url"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "ticket_question_id"
    t.integer  "project_id"
    t.integer  "cluster_id"
    t.integer  "surety_id"
  end

  add_index "tickets", ["cluster_id"], :name => "index_tickets_on_cluster_id"
  add_index "tickets", ["project_id"], :name => "index_tickets_on_project_id"
  add_index "tickets", ["state"], :name => "index_tickets_on_state"
  add_index "tickets", ["surety_id"], :name => "index_tickets_on_surety_id"
  add_index "tickets", ["user_id"], :name => "index_tickets_on_user_id"

  create_table "user_groups", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "user_groups", ["group_id"], :name => "index_user_groups_on_group_id"
  add_index "user_groups", ["user_id", "group_id"], :name => "index_user_groups_on_user_id_and_group_id", :unique => true
  add_index "user_groups", ["user_id"], :name => "index_user_groups_on_user_id"

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
    t.string   "state"
    t.string   "token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["state"], :name => "index_users_on_state"
  add_index "users", ["token"], :name => "index_users_on_token", :unique => true

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
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end

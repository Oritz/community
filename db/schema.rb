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

ActiveRecord::Schema.define(:version => 20131114091422) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "password_salt",                                        :null => false
    t.integer  "account_type",           :limit => 2,                  :null => false
    t.integer  "follower_count",                       :default => 0,  :null => false
    t.integer  "following_count",                      :default => 0,  :null => false
    t.integer  "talk_count",                           :default => 0,  :null => false
    t.integer  "subject_count",                        :default => 0,  :null => false
    t.integer  "recommend_count",                      :default => 0,  :null => false
    t.string   "nick_name",              :limit => 64,                 :null => false
    t.integer  "gender",                 :limit => 1,                  :null => false
    t.string   "avatar",                               :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "accounts", ["authentication_token"], :name => "index_accounts_on_authentication_token", :unique => true
  add_index "accounts", ["confirmation_token"], :name => "index_accounts_on_confirmation_token", :unique => true
  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["nick_name"], :name => "index_accounts_on_nick_name", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true
  add_index "accounts", ["unlock_token"], :name => "index_accounts_on_unlock_token", :unique => true

  create_table "accounts_like_posts", :id => false, :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts_like_posts", ["account_id", "post_id"], :name => "idx_accounts_like_posts_account_id_post_id"
  add_index "accounts_like_posts", ["account_id", "post_id"], :name => "uni_accounts_like_posts_account_id_post_id", :unique => true
  add_index "accounts_like_posts", ["post_id"], :name => "index_accounts_like_posts_on_post_id"

  create_table "auth_assignments", :force => true do |t|
    t.integer "item_id", :null => false
    t.integer "user_id", :null => false
    t.text    "bizrule"
    t.text    "data"
  end

  add_index "auth_assignments", ["item_id", "user_id"], :name => "index_auth_assignments_on_item_id_and_user_id", :unique => true

  create_table "auth_item_children", :id => false, :force => true do |t|
    t.integer "parent_id", :null => false
    t.integer "child_id",  :null => false
  end

  add_index "auth_item_children", ["parent_id", "child_id"], :name => "index_auth_item_children_on_parent_id_and_child_id", :unique => true

  create_table "auth_items", :force => true do |t|
    t.string  "name",        :null => false
    t.integer "auth_type"
    t.text    "description"
    t.text    "bizrule"
    t.text    "data"
  end

  add_index "auth_items", ["name"], :name => "index_auth_items_on_name", :unique => true

  create_table "client_errors", :force => true do |t|
    t.integer  "account_id", :null => false
    t.text     "err_msg",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "client_errors", ["account_id"], :name => "index_client_errors_on_account_id"

  create_table "client_updates", :force => true do |t|
    t.integer  "major_ver",       :limit => 2, :null => false
    t.integer  "minor_ver",       :limit => 2, :null => false
    t.integer  "tiny_ver",        :limit => 2, :null => false
    t.string   "patch_file"
    t.string   "patch_digest"
    t.text     "description"
    t.string   "full_pkg_file",                :null => false
    t.integer  "status",          :limit => 1, :null => false
    t.string   "full_pkg_digest"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id",                           :null => false
    t.integer  "post_author_id",                    :null => false
    t.integer  "author_id",                         :null => false
    t.string   "comment",            :limit => 140, :null => false
    t.integer  "original_id"
    t.integer  "original_author_id"
    t.integer  "status",             :limit => 1,   :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["original_author_id"], :name => "index_comments_on_original_author_id"
  add_index "comments", ["original_id"], :name => "index_comments_on_original_id"
  add_index "comments", ["post_author_id"], :name => "index_comments_on_post_author_id"
  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "conversations", :force => true do |t|
    t.integer  "first_account_id",  :null => false
    t.integer  "second_account_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "conversations", ["first_account_id", "second_account_id"], :name => "idx_conversations_first_account_id_second_account_id"
  add_index "conversations", ["first_account_id", "second_account_id"], :name => "uni_conversations_first_account_id_second_account_id", :unique => true
  add_index "conversations", ["second_account_id"], :name => "index_conversations_on_second_account_id"

  create_table "friendship", :force => true do |t|
    t.integer  "account_id",                              :null => false
    t.integer  "follower_id",                             :null => false
    t.integer  "is_mutual",   :limit => 1, :default => 0, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "friendship", ["account_id", "follower_id"], :name => "idx_friendship_account_id_follower_id"
  add_index "friendship", ["account_id", "follower_id"], :name => "uni_friendship_account_id_follower_id", :unique => true
  add_index "friendship", ["follower_id"], :name => "index_friendship_on_follower_id"

  create_table "game_files", :force => true do |t|
    t.integer  "game_id",                                   :null => false
    t.string   "file_dir",                                  :null => false
    t.string   "exe_path_name",                             :null => false
    t.integer  "crypt_type",          :limit => 1,          :null => false
    t.integer  "launcher_ver",        :limit => 2
    t.string   "game_key"
    t.string   "game_key_iv"
    t.string   "key_digest"
    t.datetime "process_start_time"
    t.datetime "process_finish_time"
    t.text     "process_result"
    t.integer  "patch_ver",                                 :null => false
    t.binary   "seed_content",        :limit => 2147483647
    t.string   "seed_digest"
    t.integer  "file_size",           :limit => 8
    t.binary   "game_shell",          :limit => 2147483647, :null => false
    t.integer  "shell_ver",                                 :null => false
    t.string   "shell_digest",                              :null => false
    t.binary   "game_ini",                                  :null => false
    t.integer  "ini_ver",                                   :null => false
    t.string   "ini_digest",                                :null => false
    t.integer  "status",              :limit => 1,          :null => false
    t.string   "comment"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "game_files", ["game_id"], :name => "index_game_files_on_game_id"

  create_table "games", :force => true do |t|
    t.string   "title",                             :null => false
    t.string   "alias_name",                        :null => false
    t.string   "dir_name",                          :null => false
    t.text     "description", :limit => 2147483647, :null => false
    t.integer  "parent_id"
    t.integer  "type",        :limit => 1,          :null => false
    t.integer  "status",      :limit => 1,          :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name",         :limit => 31,                :null => false
    t.string   "description",                               :null => false
    t.integer  "member_count",               :default => 0, :null => false
    t.integer  "creator_id",                                :null => false
    t.integer  "group_type",   :limit => 1,                 :null => false
    t.integer  "status",       :limit => 1,                 :null => false
    t.string   "logo",                                      :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "groups", ["creator_id"], :name => "index_groups_on_creator_id"

  create_table "groups_accounts", :force => true do |t|
    t.integer  "group_id",   :null => false
    t.integer  "account_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups_accounts", ["account_id"], :name => "index_groups_accounts_on_account_id"
  add_index "groups_accounts", ["group_id", "account_id"], :name => "idx_groups_accounts_group_id_account_id"
  add_index "groups_accounts", ["group_id", "account_id"], :name => "uni_groups_accounts_group_id_account_id", :unique => true

  create_table "groups_tags", :id => false, :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "tag_id",   :null => false
  end

  add_index "groups_tags", ["group_id", "tag_id"], :name => "idx_groups_tags_group_id_tag_id"
  add_index "groups_tags", ["group_id", "tag_id"], :name => "uni_groups_tags_group_id_tag_id", :unique => true
  add_index "groups_tags", ["tag_id"], :name => "index_groups_tags_on_tag_id"

  create_table "notifications", :force => true do |t|
    t.integer "followed"
    t.integer "commented"
    t.integer "recommended"
    t.integer "liked"
    t.integer "mentioned"
    t.integer "private_message"
  end

  create_table "posts", :force => true do |t|
    t.integer  "account_id",                                  :null => false
    t.string   "comment"
    t.integer  "post_type",       :limit => 1,                :null => false
    t.integer  "privilege",                                   :null => false
    t.integer  "status",          :limit => 1,                :null => false
    t.integer  "comment_count",                :default => 0, :null => false
    t.integer  "recommend_count",              :default => 0, :null => false
    t.integer  "like_count",                   :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "posts", ["account_id"], :name => "index_posts_on_account_id"

  create_table "private_messages", :force => true do |t|
    t.integer  "conversation_id",                   :null => false
    t.string   "content",                           :null => false
    t.integer  "private_message_type", :limit => 1, :null => false
    t.datetime "read_at"
    t.datetime "first_deleted_at"
    t.datetime "second_deleted_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "private_messages", ["conversation_id"], :name => "index_private_messages_on_conversation_id"

  create_table "recommends", :force => true do |t|
    t.string  "content",            :limit => 140, :null => false
    t.integer "original_id",                       :null => false
    t.integer "parent_id",                         :null => false
    t.integer "original_author_id",                :null => false
  end

  add_index "recommends", ["original_author_id"], :name => "index_recommends_on_original_author_id"
  add_index "recommends", ["original_id"], :name => "index_recommends_on_original_id"
  add_index "recommends", ["parent_id"], :name => "index_recommends_on_parent_id"

  create_table "subjects", :force => true do |t|
    t.string  "title",    :limit => 64, :null => false
    t.text    "content",                :null => false
    t.integer "group_id"
  end

  add_index "subjects", ["group_id"], :name => "index_subjects_on_group_id"

  create_table "tags", :force => true do |t|
    t.string  "name",                  :null => false
    t.integer "category", :limit => 1, :null => false
  end

  create_table "talks", :force => true do |t|
    t.string "content", :limit => 140, :null => false
  end

end

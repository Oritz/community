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

ActiveRecord::Schema.define(:version => 20131230095629) do

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
    t.integer  "exp",                                                  :null => false
    t.integer  "bonus",                                                :null => false
    t.integer  "update_tag"
    t.string   "avatar"
  end

  add_index "accounts", ["authentication_token"], :name => "index_accounts_on_authentication_token", :unique => true
  add_index "accounts", ["confirmation_token"], :name => "index_accounts_on_confirmation_token", :unique => true
  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["nick_name"], :name => "index_accounts_on_nick_name", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true
  add_index "accounts", ["unlock_token"], :name => "index_accounts_on_unlock_token", :unique => true

  create_table "accounts_exp_strategies", :id => false, :force => true do |t|
    t.integer  "account_id",      :null => false
    t.integer  "exp_strategy_id", :null => false
    t.integer  "period_count",    :null => false
    t.datetime "last_added_at"
  end

  add_index "accounts_exp_strategies", ["account_id", "exp_strategy_id"], :name => "idx_aes_ai_esi"
  add_index "accounts_exp_strategies", ["account_id", "exp_strategy_id"], :name => "uni_aes_ai_esi", :unique => true
  add_index "accounts_exp_strategies", ["exp_strategy_id"], :name => "index_accounts_exp_strategies_on_exp_strategy_id"

  create_table "accounts_game_platform_users", :id => false, :force => true do |t|
    t.integer  "account_id",            :null => false
    t.integer  "game_platform_user_id", :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "accounts_game_platform_users", ["account_id", "game_platform_user_id"], :name => "idx_accounts_game_platform_users_account_id_user_id"
  add_index "accounts_game_platform_users", ["account_id", "game_platform_user_id"], :name => "uni_accounts_game_platform_users_account_id_user_id", :unique => true
  add_index "accounts_game_platform_users", ["game_platform_user_id"], :name => "index_accounts_game_platform_users_on_game_platform_user_id"

  create_table "accounts_games", :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "game_id",    :null => false
    t.integer  "order_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts_games", ["account_id", "game_id"], :name => "idx_accounts_games_ai_gi"
  add_index "accounts_games", ["game_id"], :name => "index_accounts_games_on_game_id"
  add_index "accounts_games", ["order_id"], :name => "index_accounts_games_on_order_id"

  create_table "accounts_like_posts", :id => false, :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts_like_posts", ["account_id", "post_id"], :name => "idx_accounts_like_posts_account_id_post_id"
  add_index "accounts_like_posts", ["account_id", "post_id"], :name => "uni_accounts_like_posts_account_id_post_id", :unique => true
  add_index "accounts_like_posts", ["post_id"], :name => "index_accounts_like_posts_on_post_id"

  create_table "accounts_other_games", :id => false, :force => true do |t|
    t.integer "account_id",         :null => false
    t.integer "game_id",            :null => false
    t.integer "playtime_forever",   :null => false
    t.integer "playtime_2weeks",    :null => false
    t.integer "achievements_count", :null => false
  end

  add_index "accounts_other_games", ["account_id", "game_id"], :name => "idx_aog_ai_gi"
  add_index "accounts_other_games", ["account_id", "game_id"], :name => "uni_aog_ai_gi", :unique => true
  add_index "accounts_other_games", ["game_id"], :name => "index_accounts_other_games_on_game_id"

  create_table "accounts_tags", :id => false, :force => true do |t|
    t.integer "account_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "accounts_tags", ["account_id", "tag_id"], :name => "idx_accounts_tags_account_id_tag_id"
  add_index "accounts_tags", ["account_id", "tag_id"], :name => "uni_accounts_tags_account_id_tag_id", :unique => true
  add_index "accounts_tags", ["tag_id"], :name => "index_accounts_tags_on_tag_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "albums", :force => true do |t|
    t.integer  "account_id",                 :null => false
    t.string   "name",         :limit => 31, :null => false
    t.string   "description",                :null => false
    t.integer  "photos_count",               :null => false
    t.integer  "status",       :limit => 1,  :null => false
    t.integer  "album_type",   :limit => 1,  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "albums", ["account_id"], :name => "index_albums_on_account_id"

  create_table "all_games", :force => true do |t|
    t.string   "name",                      :null => false
    t.integer  "status",       :limit => 1, :null => false
    t.integer  "subable_id"
    t.string   "subable_type"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "image",                     :null => false
  end

  add_index "all_games", ["subable_id", "subable_type"], :name => "idx_all_games_si_st"

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

  create_table "cloud_storages", :force => true do |t|
    t.integer  "account_id",                 :null => false
    t.string   "bucket_name",  :limit => 63, :null => false
    t.string   "key",          :limit => 63, :null => false
    t.integer  "storage_type", :limit => 1,  :null => false
    t.binary   "data"
    t.integer  "private",      :limit => 1,  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "cloud_storages", ["account_id"], :name => "index_cloud_storages_on_account_id"

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

  create_table "download_servers", :force => true do |t|
    t.string   "server_ip",  :limit => 128, :null => false
    t.string   "comment"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "exp_strategies", :force => true do |t|
    t.string  "name",                     :null => false
    t.string  "app_name",                 :null => false
    t.integer "period_type", :limit => 1, :null => false
    t.integer "time_limit"
    t.integer "value",                    :null => false
    t.integer "bonus",                    :null => false
    t.integer "status",      :limit => 1, :null => false
    t.binary  "data"
  end

  add_index "exp_strategies", ["app_name"], :name => "idx_exp_strategies_app_name"
  add_index "exp_strategies", ["app_name"], :name => "uni_exp_strategies_app_name", :unique => true
  add_index "exp_strategies", ["name"], :name => "idx_exp_strategies_name"
  add_index "exp_strategies", ["name"], :name => "uni_exp_strategies_name", :unique => true

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

  create_table "game_achievements", :force => true do |t|
    t.integer  "game_id",                   :null => false
    t.string   "name",                      :null => false
    t.text     "description",               :null => false
    t.string   "lock_url",                  :null => false
    t.string   "unlock_url",                :null => false
    t.integer  "status",       :limit => 1, :null => false
    t.integer  "subable_id",                :null => false
    t.string   "subable_type",              :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "game_achievements", ["game_id"], :name => "index_game_achievements_on_game_id"
  add_index "game_achievements", ["subable_id", "subable_type"], :name => "idx_ga_si_st"

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

  create_table "game_platform_users", :force => true do |t|
    t.integer  "game_platform_id",                   :null => false
    t.string   "game_platform_account",              :null => false
    t.integer  "bind_count",                         :null => false
    t.integer  "game_count",                         :null => false
    t.datetime "latest_time"
    t.integer  "status",                :limit => 1, :null => false
  end

  add_index "game_platform_users", ["game_platform_account"], :name => "index_game_platform_users_on_game_platform_account"
  add_index "game_platform_users", ["game_platform_id", "game_platform_account"], :name => "idx_gau_id_account"
  add_index "game_platform_users", ["game_platform_id", "game_platform_account"], :name => "uni_gau_id_account", :unique => true

  create_table "game_platform_users_game_achievements", :id => false, :force => true do |t|
    t.integer  "game_platform_user_id", :null => false
    t.integer  "game_achievement_id",   :null => false
    t.datetime "unlocked_at"
  end

  add_index "game_platform_users_game_achievements", ["game_achievement_id"], :name => "idx_gpuga_game_achievement_id"
  add_index "game_platform_users_game_achievements", ["game_platform_user_id", "game_achievement_id"], :name => "idx_gpuga_user_id_achievement_id"
  add_index "game_platform_users_game_achievements", ["game_platform_user_id", "game_achievement_id"], :name => "uni_gpuga_user_id_achievement_id", :unique => true

  create_table "game_platform_users_games", :id => false, :force => true do |t|
    t.integer "game_platform_user_id",  :null => false
    t.integer "game_id",                :null => false
    t.integer "playtime_count",         :null => false
    t.integer "game_achievement_count", :null => false
  end

  add_index "game_platform_users_games", ["game_id"], :name => "index_game_platform_users_games_on_game_id"
  add_index "game_platform_users_games", ["game_platform_user_id", "game_id"], :name => "idx_game_platform_users_games_user_id_game_id"
  add_index "game_platform_users_games", ["game_platform_user_id", "game_id"], :name => "uni_game_platform_users_games_user_id_game_id", :unique => true

  create_table "game_platforms", :force => true do |t|
    t.string  "name",          :limit => 31, :null => false
    t.string  "api_key"
    t.integer "platform_type", :limit => 1
  end

  add_index "game_platforms", ["name"], :name => "index_game_platforms_on_name", :unique => true

  create_table "game_serial_numbers", :force => true do |t|
    t.integer  "game_id",                      :null => false
    t.integer  "serial_type",                  :null => false
    t.integer  "batch_number",                 :null => false
    t.string   "serial_number", :limit => 128, :null => false
    t.integer  "status",        :limit => 1,   :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "game_serial_numbers", ["game_id", "serial_type", "status"], :name => "index_game_serial_numbers_on_game_id_and_serial_type_and_status"
  add_index "game_serial_numbers", ["game_id"], :name => "index_game_serial_numbers_on_game_id"
  add_index "game_serial_numbers", ["serial_type"], :name => "index_game_serial_numbers_on_serial_type"

  create_table "game_serial_types", :force => true do |t|
    t.integer "game_id",     :null => false
    t.integer "serial_type", :null => false
  end

  add_index "game_serial_types", ["game_id", "serial_type"], :name => "index_game_serial_types_on_game_id_and_serial_type"
  add_index "game_serial_types", ["serial_type"], :name => "index_game_serial_types_on_serial_type"

  create_table "games", :force => true do |t|
    t.string   "title",                                                              :null => false
    t.string   "alias_name",                                                         :null => false
    t.string   "dir_name",                                                           :null => false
    t.text     "description",   :limit => 2147483647,                                :null => false
    t.integer  "parent_id"
    t.integer  "status",        :limit => 1,                                         :null => false
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at"
    t.string   "cap_image"
    t.string   "icon_image"
    t.string   "product_image"
    t.decimal  "rating",                              :precision => 10, :scale => 0
    t.string   "forum_addr"
    t.string   "install_type",                                                       :null => false
    t.string   "game_tag",                                                           :null => false
    t.string   "manual"
    t.integer  "release_date"
    t.string   "link",          :limit => 1024
    t.decimal  "sell_price",                          :precision => 10, :scale => 0, :null => false
    t.decimal  "list_price",                          :precision => 10, :scale => 0, :null => false
    t.integer  "downloadable",                                                       :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name",            :limit => 31,                :null => false
    t.string   "description",                                  :null => false
    t.integer  "member_count",                  :default => 0, :null => false
    t.integer  "creator_id",                                   :null => false
    t.integer  "group_type",      :limit => 1,                 :null => false
    t.integer  "status",          :limit => 1,                 :null => false
    t.string   "logo",                                         :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "talk_count",                                   :null => false
    t.integer  "subject_count",                                :null => false
    t.integer  "recommend_count",                              :null => false
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

  create_table "launchers", :force => true do |t|
    t.integer  "crypt_type",     :limit => 1, :null => false
    t.binary   "protector",                   :null => false
    t.string   "protect_cmd",                 :null => false
    t.string   "root_key",                    :null => false
    t.string   "root_key_iv",                 :null => false
    t.string   "key_digest",                  :null => false
    t.binary   "launcher",                    :null => false
    t.string   "launcer_name",                :null => false
    t.string   "launcer_digest",              :null => false
    t.string   "launcher_cmd",                :null => false
    t.integer  "ver",                         :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer "followed"
    t.integer "commented"
    t.integer "recommended"
    t.integer "liked"
    t.integer "mentioned"
    t.integer "private_message"
  end

  create_table "order_games", :id => false, :force => true do |t|
    t.integer  "order_id",          :null => false
    t.integer  "account_id",        :null => false
    t.integer  "game_id",           :null => false
    t.integer  "drupal_account_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "order_games", ["account_id", "game_id", "order_id"], :name => "idx_order_games_ai_gi_oi"

  create_table "orders", :force => true do |t|
    t.integer  "account_id",                                                  :null => false
    t.string   "user_ip"
    t.string   "payment_method", :limit => 32
    t.decimal  "subtotal",                     :precision => 10, :scale => 0, :null => false
    t.string   "order_status",   :limit => 32,                                :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "orders", ["account_id"], :name => "index_orders_on_account_id"

  create_table "photos", :force => true do |t|
    t.integer  "album_id",                      :null => false
    t.integer  "account_id",                    :null => false
    t.integer  "cloud_storage_id",              :null => false
    t.string   "description",                   :null => false
    t.integer  "status",           :limit => 1, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "photos", ["account_id"], :name => "index_photos_on_account_id"
  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"
  add_index "photos", ["cloud_storage_id"], :name => "index_photos_on_cloud_storage_id"

  create_table "post_images", :force => true do |t|
    t.integer "post_id",                        :null => false
    t.integer "cloud_storage_id",               :null => false
    t.string  "comment",          :limit => 31
  end

  add_index "post_images", ["cloud_storage_id"], :name => "index_post_images_on_cloud_storage_id"
  add_index "post_images", ["post_id"], :name => "index_post_images_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "account_id",                                  :null => false
    t.string   "recommendation"
    t.integer  "privilege",                                   :null => false
    t.integer  "status",          :limit => 1,                :null => false
    t.integer  "comment_count",                :default => 0, :null => false
    t.integer  "recommend_count",              :default => 0, :null => false
    t.integer  "like_count",                   :default => 0, :null => false
    t.string   "detail_type"
    t.integer  "detail_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "group_id"
    t.integer  "original_id"
    t.integer  "parent_id"
  end

  add_index "posts", ["account_id"], :name => "index_posts_on_account_id"
  add_index "posts", ["detail_id", "detail_type"], :name => "idx_posts_detail_id_type"
  add_index "posts", ["detail_id", "detail_type"], :name => "uni_posts_detail_id_type", :unique => true
  add_index "posts", ["group_id"], :name => "index_posts_on_group_id"
  add_index "posts", ["original_id"], :name => "index_posts_on_original_id"
  add_index "posts", ["parent_id"], :name => "index_posts_on_parent_id"

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

  create_table "recommendations", :force => true do |t|
    t.integer  "recommend_type", :limit => 1, :null => false
    t.integer  "weight",         :limit => 1, :null => false
    t.integer  "sub_type",       :limit => 1
    t.string   "full_pic"
    t.string   "thumb_pic"
    t.string   "title"
    t.text     "comment"
    t.string   "link",                        :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "serial_types", :force => true do |t|
    t.string  "type_name", :limit => 64, :null => false
    t.string  "type_desc",               :null => false
    t.integer "type_cat",  :limit => 2,  :null => false
  end

  add_index "serial_types", ["type_name"], :name => "idx_serial_types_type_name"
  add_index "serial_types", ["type_name"], :name => "uni_serial_types_type_name", :unique => true

  create_table "steam_friends", :id => false, :force => true do |t|
    t.integer  "steam_user_id", :null => false
    t.integer  "friend_id",     :null => false
    t.datetime "friend_since",  :null => false
  end

  add_index "steam_friends", ["friend_id"], :name => "index_steam_friends_on_friend_id"
  add_index "steam_friends", ["steam_user_id", "friend_id"], :name => "idx_steam_friends_sui_fi"
  add_index "steam_friends", ["steam_user_id", "friend_id"], :name => "uni_steam_friends_sui_fi", :unique => true

  create_table "steam_game_achievements", :force => true do |t|
    t.string  "api_name",      :null => false
    t.float   "percent"
    t.integer "steam_game_id", :null => false
  end

  add_index "steam_game_achievements", ["api_name"], :name => "index_steam_game_achievements_on_api_name"
  add_index "steam_game_achievements", ["steam_game_id", "api_name"], :name => "idx_sga_sgi_an"
  add_index "steam_game_achievements", ["steam_game_id", "api_name"], :name => "uni_sga_sgi_an", :unique => true

  create_table "steam_games", :force => true do |t|
    t.integer "appid", :null => false
  end

  add_index "steam_games", ["appid"], :name => "idx_steam_games_appid"
  add_index "steam_games", ["appid"], :name => "uni_steam_games_appid", :unique => true

  create_table "steam_users", :force => true do |t|
    t.integer "account_id"
    t.string  "steamid",                  :limit => 63, :null => false
    t.string  "personaname"
    t.string  "profile_url"
    t.string  "avatar"
    t.integer "communityvisibilitystate", :limit => 1
    t.integer "profilestate",             :limit => 1
    t.integer "lastlogoff"
    t.integer "commentpermission",        :limit => 1
    t.string  "realname"
    t.string  "primaryclanid"
    t.integer "timecreated"
    t.string  "loccountrycode",           :limit => 15
    t.string  "locstatecode",             :limit => 15
    t.integer "loccityid"
  end

  add_index "steam_users", ["account_id"], :name => "index_steam_users_on_account_id"
  add_index "steam_users", ["steamid"], :name => "idx_steam_users_steamid"
  add_index "steam_users", ["steamid"], :name => "uni_steam_users_steamid", :unique => true

  create_table "steam_users_game_achievements", :id => false, :force => true do |t|
    t.integer  "steam_user_id",       :null => false
    t.integer  "game_achievement_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "steam_users_game_achievements", ["game_achievement_id"], :name => "index_steam_users_game_achievements_on_game_achievement_id"
  add_index "steam_users_game_achievements", ["steam_user_id", "game_achievement_id"], :name => "idx_suga_sui_gai"
  add_index "steam_users_game_achievements", ["steam_user_id", "game_achievement_id"], :name => "uni_suga_sui_gai", :unique => true

  create_table "steam_users_games", :id => false, :force => true do |t|
    t.integer "steam_user_id",                            :null => false
    t.integer "game_id",                                  :null => false
    t.integer "playtime_forever"
    t.integer "playtime_2weeks"
    t.integer "has_community_visible_stats", :limit => 1, :null => false
    t.integer "achievements_count",                       :null => false
  end

  add_index "steam_users_games", ["game_id"], :name => "index_steam_users_games_on_game_id"
  add_index "steam_users_games", ["steam_user_id", "game_id"], :name => "idx_sug_sui_gi"
  add_index "steam_users_games", ["steam_user_id", "game_id"], :name => "uni_sug_sui_gi", :unique => true

  create_table "subjects", :force => true do |t|
    t.string "title",     :limit => 64
    t.string "content",   :limit => 140
    t.text   "main_body"
  end

  create_table "tags", :force => true do |t|
    t.string  "name",                  :null => false
    t.integer "category", :limit => 1, :null => false
  end

  create_table "talks", :force => true do |t|
    t.string "content", :limit => 140, :null => false
  end

  create_table "user_actions", :force => true do |t|
    t.integer  "account_id",               :null => false
    t.integer  "action_type", :limit => 2, :null => false
    t.string   "object_name"
    t.datetime "created_at",               :null => false
  end

  add_index "user_actions", ["account_id"], :name => "index_user_actions_on_account_id"
  add_index "user_actions", ["action_type"], :name => "index_user_actions_on_action_type"
  add_index "user_actions", ["object_name"], :name => "index_user_actions_on_object_name"

  create_table "user_envs", :force => true do |t|
    t.integer  "account_id",                     :null => false
    t.string   "machine_id",                     :null => false
    t.string   "os",                             :null => false
    t.string   "cpu",                            :null => false
    t.integer  "ram",                            :null => false
    t.integer  "hdd",                            :null => false
    t.string   "graphics_card",                  :null => false
    t.integer  "screen_w",          :limit => 2, :null => false
    t.integer  "screen_h",          :limit => 2, :null => false
    t.string   "mac_address",                    :null => false
    t.integer  "dx_ver_major",      :limit => 2, :null => false
    t.integer  "dx_ver_minor",      :limit => 2, :null => false
    t.integer  "dx_ver_tiny",       :limit => 2, :null => false
    t.integer  "dot_net_ver_major", :limit => 2, :null => false
    t.integer  "dot_net_ver_minor", :limit => 2, :null => false
    t.integer  "dot_net_ver_tiny",  :limit => 2, :null => false
    t.integer  "vc_rt_ver_major",   :limit => 2, :null => false
    t.integer  "vc_rt_ver_minor",   :limit => 2, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "user_envs", ["account_id"], :name => "index_user_envs_on_account_id"

  create_table "user_game_play_histories", :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "game_id",    :null => false
    t.datetime "start_time", :null => false
    t.datetime "exit_time"
  end

  add_index "user_game_play_histories", ["account_id", "game_id"], :name => "idx_ugph_ai_gi"
  add_index "user_game_play_histories", ["exit_time"], :name => "index_user_game_play_histories_on_exit_time"
  add_index "user_game_play_histories", ["game_id"], :name => "index_user_game_play_histories_on_game_id"
  add_index "user_game_play_histories", ["start_time"], :name => "index_user_game_play_histories_on_start_time"

  create_table "user_game_serials", :force => true do |t|
    t.integer  "account_id",                   :null => false
    t.integer  "game_id",                      :null => false
    t.integer  "serial_type",                  :null => false
    t.string   "serial_number", :limit => 128, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "user_game_serials", ["account_id"], :name => "index_user_game_serials_on_account_id"
  add_index "user_game_serials", ["game_id"], :name => "index_user_game_serials_on_game_id"
  add_index "user_game_serials", ["serial_type"], :name => "index_user_game_serials_on_serial_type"

  create_table "users_games_reputation_ranklists", :force => true do |t|
    t.integer "game_id",                       :null => false
    t.integer "user_id",                       :null => false
    t.string  "user_type",                     :null => false
    t.integer "reputation",                    :null => false
    t.integer "delta_reputation",              :null => false
    t.integer "rank",             :limit => 1, :null => false
  end

  add_index "users_games_reputation_ranklists", ["game_id"], :name => "index_users_games_reputation_ranklists_on_game_id"
  add_index "users_games_reputation_ranklists", ["user_id", "user_type", "game_id"], :name => "idx_ugrr_ui_ut_gi"
  add_index "users_games_reputation_ranklists", ["user_id", "user_type", "game_id"], :name => "uni_ugrr_ui_ut_gi", :unique => true

end

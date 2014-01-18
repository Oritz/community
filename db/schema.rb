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

ActiveRecord::Schema.define(:version => 20140113071727) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                                :null => false
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
  add_index "accounts_games", ["order_id"], :name => "index_accounts_games_on_accounts_order_id"

  create_table "accounts_games_bak", :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "game_id",    :null => false
    t.integer  "order_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts_games_bak", ["account_id", "game_id"], :name => "idx_accounts_games_ai_gi"
  add_index "accounts_games_bak", ["game_id"], :name => "index_accounts_games_on_game_id"
  add_index "accounts_games_bak", ["order_id"], :name => "index_accounts_games_on_accounts_order_id"

  create_table "accounts_like_posts", :id => false, :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "post_id",    :null => false
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

  create_table "actions", :primary_key => "aid", :force => true do |t|
    t.string "type",       :limit => 32,         :default => "",  :null => false
    t.string "callback",                         :default => "",  :null => false
    t.binary "parameters", :limit => 2147483647,                  :null => false
    t.string "label",                            :default => "0", :null => false
  end

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

  create_table "apachesolr_environment", :primary_key => "env_id", :force => true do |t|
    t.string "name",                          :default => "", :null => false
    t.string "url",           :limit => 1000,                 :null => false
    t.string "service_class",                 :default => "", :null => false
  end

  create_table "apachesolr_environment_variable", :id => false, :force => true do |t|
    t.string "env_id", :limit => 64,                         :null => false
    t.string "name",   :limit => 128,        :default => "", :null => false
    t.binary "value",  :limit => 2147483647,                 :null => false
  end

  create_table "apachesolr_index_bundles", :id => false, :force => true do |t|
    t.string "env_id",      :limit => 64,  :null => false
    t.string "entity_type", :limit => 32,  :null => false
    t.string "bundle",      :limit => 128, :null => false
  end

  create_table "apachesolr_index_entities", :id => false, :force => true do |t|
    t.string  "entity_type", :limit => 32,                 :null => false
    t.integer "entity_id",                                 :null => false
    t.string  "bundle",      :limit => 128,                :null => false
    t.integer "status",                     :default => 1, :null => false
    t.integer "changed",                    :default => 0, :null => false
  end

  add_index "apachesolr_index_entities", ["bundle", "changed"], :name => "bundle_changed"

  create_table "apachesolr_index_entities_node", :primary_key => "entity_id", :force => true do |t|
    t.string  "entity_type", :limit => 32,                 :null => false
    t.string  "bundle",      :limit => 128,                :null => false
    t.integer "status",                     :default => 1, :null => false
    t.integer "changed",                    :default => 0, :null => false
  end

  add_index "apachesolr_index_entities_node", ["bundle", "changed"], :name => "bundle_changed"

  create_table "apachesolr_search_page", :primary_key => "page_id", :force => true do |t|
    t.string "label",       :limit => 32, :default => "", :null => false
    t.string "description",               :default => "", :null => false
    t.string "search_path",               :default => "", :null => false
    t.string "page_title",                :default => "", :null => false
    t.string "env_id",      :limit => 64, :default => "", :null => false
    t.text   "settings"
  end

  add_index "apachesolr_search_page", ["env_id"], :name => "env_id"

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

  create_table "authmap", :primary_key => "aid", :force => true do |t|
    t.integer "uid",                     :default => 0,  :null => false
    t.string  "authname", :limit => 128, :default => "", :null => false
    t.string  "module",   :limit => 128, :default => "", :null => false
  end

  add_index "authmap", ["authname"], :name => "authname", :unique => true

  create_table "batch", :primary_key => "bid", :force => true do |t|
    t.string  "token",     :limit => 64,         :null => false
    t.integer "timestamp",                       :null => false
    t.binary  "batch",     :limit => 2147483647
  end

  add_index "batch", ["token"], :name => "token"

  create_table "block", :primary_key => "bid", :force => true do |t|
    t.string  "module",     :limit => 64, :default => "",  :null => false
    t.string  "delta",      :limit => 32, :default => "0", :null => false
    t.string  "theme",      :limit => 64, :default => "",  :null => false
    t.integer "status",     :limit => 1,  :default => 0,   :null => false
    t.integer "weight",                   :default => 0,   :null => false
    t.string  "region",     :limit => 64, :default => "",  :null => false
    t.integer "custom",     :limit => 1,  :default => 0,   :null => false
    t.integer "visibility", :limit => 1,  :default => 0,   :null => false
    t.text    "pages",                                     :null => false
    t.string  "title",      :limit => 64, :default => "",  :null => false
    t.integer "cache",      :limit => 1,  :default => 1,   :null => false
  end

  add_index "block", ["theme", "module", "delta"], :name => "tmd", :unique => true
  add_index "block", ["theme", "status", "region", "weight", "module"], :name => "list"

  create_table "block_custom", :primary_key => "bid", :force => true do |t|
    t.text   "body",   :limit => 2147483647
    t.string "info",   :limit => 128,        :default => "", :null => false
    t.string "format"
  end

  add_index "block_custom", ["info"], :name => "info", :unique => true

  create_table "block_node_type", :id => false, :force => true do |t|
    t.string "module", :limit => 64, :null => false
    t.string "delta",  :limit => 32, :null => false
    t.string "type",   :limit => 32, :null => false
  end

  add_index "block_node_type", ["type"], :name => "type"

  create_table "block_role", :id => false, :force => true do |t|
    t.string  "module", :limit => 64, :null => false
    t.string  "delta",  :limit => 32, :null => false
    t.integer "rid",                  :null => false
  end

  add_index "block_role", ["rid"], :name => "rid"

  create_table "blocked_ips", :primary_key => "iid", :force => true do |t|
    t.string "ip", :limit => 40, :default => "", :null => false
  end

  add_index "blocked_ips", ["ip"], :name => "blocked_ip"

  create_table "bulk_send_coupons", :primary_key => "bscid", :force => true do |t|
    t.string  "name",                        :default => "", :null => false
    t.string  "description",                 :default => ""
    t.integer "cid",                         :default => 0,  :null => false
    t.integer "task_type",      :limit => 1, :default => 0,  :null => false
    t.text    "task_condition"
    t.integer "created",                     :default => 0,  :null => false
  end

  create_table "bulk_send_coupons_records", :primary_key => "rid", :force => true do |t|
    t.integer "uid",                    :default => 0,  :null => false
    t.integer "bscid",                  :default => 0,  :null => false
    t.integer "cid",                    :default => 0,  :null => false
    t.string  "code",     :limit => 63, :default => "", :null => false
    t.integer "notified", :limit => 1,  :default => 0,  :null => false
    t.integer "updated",                :default => 0,  :null => false
  end

  create_table "cache", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache", ["expire"], :name => "expire"

  create_table "cache_apachesolr", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_apachesolr", ["expire"], :name => "expire"

  create_table "cache_block", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_block", ["expire"], :name => "expire"

  create_table "cache_bootstrap", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_bootstrap", ["expire"], :name => "expire"

  create_table "cache_field", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_field", ["expire"], :name => "expire"

  create_table "cache_filter", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_filter", ["expire"], :name => "expire"

  create_table "cache_form", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_form", ["expire"], :name => "expire"

  create_table "cache_image", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_image", ["expire"], :name => "expire"

  create_table "cache_menu", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_menu", ["expire"], :name => "expire"

  create_table "cache_page", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_page", ["expire"], :name => "expire"

  create_table "cache_path", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_path", ["expire"], :name => "expire"

  create_table "cache_rules", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_rules", ["expire"], :name => "expire"

  create_table "cache_update", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_update", ["expire"], :name => "expire"

  create_table "cache_views", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 0, :null => false
  end

  add_index "cache_views", ["expire"], :name => "expire"

  create_table "cache_views_data", :primary_key => "cid", :force => true do |t|
    t.binary  "data",       :limit => 2147483647
    t.integer "expire",                           :default => 0, :null => false
    t.integer "created",                          :default => 0, :null => false
    t.integer "serialized", :limit => 2,          :default => 1, :null => false
  end

  add_index "cache_views_data", ["expire"], :name => "expire"

  create_table "ckeditor_input_format", :id => false, :force => true do |t|
    t.string "name",   :limit => 128, :default => "", :null => false
    t.string "format", :limit => 128, :default => "", :null => false
  end

  create_table "ckeditor_settings", :primary_key => "name", :force => true do |t|
    t.text "settings"
  end

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

  create_table "cn_ips", :force => true do |t|
    t.integer "begin", :limit => 8, :null => false
    t.integer "end",   :limit => 8, :null => false
  end

  add_index "cn_ips", ["begin"], :name => "begin"
  add_index "cn_ips", ["end"], :name => "end"

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

  create_table "conditional_fields", :force => true do |t|
    t.integer "dependee",                        :null => false
    t.integer "dependent",                       :null => false
    t.binary  "options",   :limit => 2147483647, :null => false
  end

  create_table "conversations", :force => true do |t|
    t.integer  "first_account_id",  :null => false
    t.integer  "second_account_id", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "conversations", ["first_account_id", "second_account_id"], :name => "idx_conversations_first_account_id_second_account_id"
  add_index "conversations", ["first_account_id", "second_account_id"], :name => "uni_conversations_first_account_id_second_account_id", :unique => true
  add_index "conversations", ["second_account_id"], :name => "index_conversations_on_second_account_id"

  create_table "ctools_css_cache", :primary_key => "cid", :force => true do |t|
    t.string  "filename"
    t.text    "css",      :limit => 2147483647
    t.integer "filter",   :limit => 1
  end

  create_table "ctools_object_cache", :id => false, :force => true do |t|
    t.string  "sid",     :limit => 64,                        :null => false
    t.string  "name",    :limit => 128,                       :null => false
    t.string  "obj",     :limit => 32,                        :null => false
    t.integer "updated",                       :default => 0, :null => false
    t.text    "data",    :limit => 2147483647
  end

  add_index "ctools_object_cache", ["updated"], :name => "updated"

  create_table "date_format_locale", :id => false, :force => true do |t|
    t.string "format",   :limit => 100, :null => false
    t.string "type",     :limit => 64,  :null => false
    t.string "language", :limit => 12,  :null => false
  end

  create_table "date_format_type", :primary_key => "type", :force => true do |t|
    t.string  "title",                              :null => false
    t.integer "locked", :limit => 1, :default => 0, :null => false
  end

  add_index "date_format_type", ["title"], :name => "title"

  create_table "date_formats", :primary_key => "dfid", :force => true do |t|
    t.string  "format", :limit => 100,                :null => false
    t.string  "type",   :limit => 64,                 :null => false
    t.integer "locked", :limit => 1,   :default => 0, :null => false
  end

  add_index "date_formats", ["format", "type"], :name => "formats", :unique => true

  create_table "download_servers", :force => true do |t|
    t.string   "server_ip",  :limit => 128, :null => false
    t.string   "comment"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "drupal_sessions", :id => false, :force => true do |t|
    t.integer "uid",                                             :null => false
    t.string  "sid",       :limit => 128,                        :null => false
    t.string  "ssid",      :limit => 128,        :default => "", :null => false
    t.string  "hostname",  :limit => 128,        :default => "", :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
    t.integer "cache",                           :default => 0,  :null => false
    t.binary  "session",   :limit => 2147483647
  end

  add_index "drupal_sessions", ["ssid"], :name => "ssid"
  add_index "drupal_sessions", ["timestamp"], :name => "timestamp"
  add_index "drupal_sessions", ["uid"], :name => "uid"

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

  create_table "facetapi", :primary_key => "name", :force => true do |t|
    t.string  "searcher", :limit => 64, :default => "", :null => false
    t.string  "realm",    :limit => 64, :default => "", :null => false
    t.string  "facet",                  :default => "", :null => false
    t.integer "enabled",  :limit => 1,  :default => 0,  :null => false
    t.binary  "settings"
  end

  create_table "field_config", :force => true do |t|
    t.string  "field_name",     :limit => 32,                         :null => false
    t.string  "type",           :limit => 128,                        :null => false
    t.string  "module",         :limit => 128,        :default => "", :null => false
    t.integer "active",         :limit => 1,          :default => 0,  :null => false
    t.string  "storage_type",   :limit => 128,                        :null => false
    t.string  "storage_module", :limit => 128,        :default => "", :null => false
    t.integer "storage_active", :limit => 1,          :default => 0,  :null => false
    t.integer "locked",         :limit => 1,          :default => 0,  :null => false
    t.binary  "data",           :limit => 2147483647,                 :null => false
    t.integer "cardinality",    :limit => 1,          :default => 0,  :null => false
    t.integer "translatable",   :limit => 1,          :default => 0,  :null => false
    t.integer "deleted",        :limit => 1,          :default => 0,  :null => false
  end

  add_index "field_config", ["active"], :name => "active"
  add_index "field_config", ["deleted"], :name => "deleted"
  add_index "field_config", ["field_name"], :name => "field_name"
  add_index "field_config", ["module"], :name => "module"
  add_index "field_config", ["storage_active"], :name => "storage_active"
  add_index "field_config", ["storage_module"], :name => "storage_module"
  add_index "field_config", ["storage_type"], :name => "storage_type"
  add_index "field_config", ["type"], :name => "type"

  create_table "field_config_instance", :force => true do |t|
    t.integer "field_id",                                          :null => false
    t.string  "field_name",  :limit => 32,         :default => "", :null => false
    t.string  "entity_type", :limit => 32,         :default => "", :null => false
    t.string  "bundle",      :limit => 128,        :default => "", :null => false
    t.binary  "data",        :limit => 2147483647,                 :null => false
    t.integer "deleted",     :limit => 1,          :default => 0,  :null => false
  end

  add_index "field_config_instance", ["deleted"], :name => "deleted"
  add_index "field_config_instance", ["field_name", "entity_type", "bundle"], :name => "field_name_bundle"

  create_table "field_data_body", :id => false, :force => true do |t|
    t.string  "entity_type",  :limit => 128,        :default => "", :null => false
    t.string  "bundle",       :limit => 128,        :default => "", :null => false
    t.integer "deleted",      :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",     :limit => 32,         :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.text    "body_value",   :limit => 2147483647
    t.text    "body_summary", :limit => 2147483647
    t.string  "body_format"
  end

  add_index "field_data_body", ["body_format"], :name => "body_format"
  add_index "field_data_body", ["bundle"], :name => "bundle"
  add_index "field_data_body", ["deleted"], :name => "deleted"
  add_index "field_data_body", ["entity_id"], :name => "entity_id"
  add_index "field_data_body", ["entity_type"], :name => "entity_type"
  add_index "field_data_body", ["language"], :name => "language"
  add_index "field_data_body", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_alias", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id"
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_alias_value"
    t.string  "field_alias_format"
  end

  add_index "field_data_field_alias", ["bundle"], :name => "bundle"
  add_index "field_data_field_alias", ["deleted"], :name => "deleted"
  add_index "field_data_field_alias", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_alias", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_alias", ["field_alias_format"], :name => "field_alias_format"
  add_index "field_data_field_alias", ["language"], :name => "language"
  add_index "field_data_field_alias", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_attachment", :id => false, :force => true do |t|
    t.string  "entity_type",                  :limit => 128, :default => "", :null => false
    t.string  "bundle",                       :limit => 128, :default => "", :null => false
    t.integer "deleted",                      :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                   :null => false
    t.integer "revision_id"
    t.string  "language",                     :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                       :null => false
    t.integer "field_attachment_fid"
    t.integer "field_attachment_display",     :limit => 1,   :default => 1,  :null => false
    t.text    "field_attachment_description"
  end

  add_index "field_data_field_attachment", ["bundle"], :name => "bundle"
  add_index "field_data_field_attachment", ["deleted"], :name => "deleted"
  add_index "field_data_field_attachment", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_attachment", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_attachment", ["field_attachment_fid"], :name => "field_attachment_fid"
  add_index "field_data_field_attachment", ["language"], :name => "language"
  add_index "field_data_field_attachment", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_copyright", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128,        :default => "", :null => false
    t.string  "bundle",                 :limit => 128,        :default => "", :null => false
    t.integer "deleted",                :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                    :null => false
    t.integer "revision_id"
    t.string  "language",               :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                        :null => false
    t.text    "field_copyright_value",  :limit => 2147483647
    t.string  "field_copyright_format"
  end

  add_index "field_data_field_copyright", ["bundle"], :name => "bundle"
  add_index "field_data_field_copyright", ["deleted"], :name => "deleted"
  add_index "field_data_field_copyright", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_copyright", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_copyright", ["field_copyright_format"], :name => "field_copyright_format"
  add_index "field_data_field_copyright", ["language"], :name => "language"
  add_index "field_data_field_copyright", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_desc", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id"
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.string  "field_desc_value"
    t.string  "field_desc_format"
  end

  add_index "field_data_field_desc", ["bundle"], :name => "bundle"
  add_index "field_data_field_desc", ["deleted"], :name => "deleted"
  add_index "field_data_field_desc", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_desc", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_desc", ["field_desc_format"], :name => "field_desc_format"
  add_index "field_data_field_desc", ["language"], :name => "language"
  add_index "field_data_field_desc", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_developer", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_developer_tid"
  end

  add_index "field_data_field_developer", ["bundle"], :name => "bundle"
  add_index "field_data_field_developer", ["deleted"], :name => "deleted"
  add_index "field_data_field_developer", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_developer", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_developer", ["field_developer_tid"], :name => "field_developer_tid"
  add_index "field_data_field_developer", ["language"], :name => "language"
  add_index "field_data_field_developer", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_english_name", :id => false, :force => true do |t|
    t.string  "entity_type",               :limit => 128, :default => "", :null => false
    t.string  "bundle",                    :limit => 128, :default => "", :null => false
    t.integer "deleted",                   :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                :null => false
    t.integer "revision_id"
    t.string  "language",                  :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                    :null => false
    t.string  "field_english_name_value"
    t.string  "field_english_name_format"
  end

  add_index "field_data_field_english_name", ["bundle"], :name => "bundle"
  add_index "field_data_field_english_name", ["deleted"], :name => "deleted"
  add_index "field_data_field_english_name", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_english_name", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_english_name", ["field_english_name_format"], :name => "field_english_name_format"
  add_index "field_data_field_english_name", ["language"], :name => "language"
  add_index "field_data_field_english_name", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_filesize", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128,                                :default => "", :null => false
    t.string  "bundle",               :limit => 128,                                :default => "", :null => false
    t.integer "deleted",              :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                          :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                              :null => false
    t.decimal "field_filesize_value",                :precision => 10, :scale => 2
  end

  add_index "field_data_field_filesize", ["bundle"], :name => "bundle"
  add_index "field_data_field_filesize", ["deleted"], :name => "deleted"
  add_index "field_data_field_filesize", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_filesize", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_filesize", ["language"], :name => "language"
  add_index "field_data_field_filesize", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_forum_addr", :id => false, :force => true do |t|
    t.string  "entity_type",             :limit => 128, :default => "", :null => false
    t.string  "bundle",                  :limit => 128, :default => "", :null => false
    t.integer "deleted",                 :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                              :null => false
    t.integer "revision_id"
    t.string  "language",                :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                  :null => false
    t.string  "field_forum_addr_value"
    t.string  "field_forum_addr_format"
  end

  add_index "field_data_field_forum_addr", ["bundle"], :name => "bundle"
  add_index "field_data_field_forum_addr", ["deleted"], :name => "deleted"
  add_index "field_data_field_forum_addr", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_forum_addr", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_forum_addr", ["field_forum_addr_format"], :name => "field_forum_addr_format"
  add_index "field_data_field_forum_addr", ["language"], :name => "language"
  add_index "field_data_field_forum_addr", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_game", :id => false, :force => true do |t|
    t.string  "entity_type",    :limit => 128, :default => "", :null => false
    t.string  "bundle",         :limit => 128, :default => "", :null => false
    t.integer "deleted",        :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                     :null => false
    t.integer "revision_id"
    t.string  "language",       :limit => 32,  :default => "", :null => false
    t.integer "delta",                                         :null => false
    t.integer "field_game_nid"
  end

  add_index "field_data_field_game", ["bundle"], :name => "bundle"
  add_index "field_data_field_game", ["deleted"], :name => "deleted"
  add_index "field_data_field_game", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_game", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_game", ["field_game_nid"], :name => "field_game_nid"
  add_index "field_data_field_game", ["language"], :name => "language"
  add_index "field_data_field_game", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_game_tag", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_game_tag_value"
  end

  add_index "field_data_field_game_tag", ["bundle"], :name => "bundle"
  add_index "field_data_field_game_tag", ["deleted"], :name => "deleted"
  add_index "field_data_field_game_tag", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_game_tag", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_game_tag", ["field_game_tag_value"], :name => "field_game_tag_value"
  add_index "field_data_field_game_tag", ["language"], :name => "language"
  add_index "field_data_field_game_tag", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_genera", :id => false, :force => true do |t|
    t.string  "entity_type",      :limit => 128, :default => "", :null => false
    t.string  "bundle",           :limit => 128, :default => "", :null => false
    t.integer "deleted",          :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                       :null => false
    t.integer "revision_id"
    t.string  "language",         :limit => 32,  :default => "", :null => false
    t.integer "delta",                                           :null => false
    t.integer "field_genera_tid"
  end

  add_index "field_data_field_genera", ["bundle"], :name => "bundle"
  add_index "field_data_field_genera", ["deleted"], :name => "deleted"
  add_index "field_data_field_genera", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_genera", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_genera", ["field_genera_tid"], :name => "field_genera_tid"
  add_index "field_data_field_genera", ["language"], :name => "language"
  add_index "field_data_field_genera", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_hidden", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id"
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.integer "field_hidden_value"
  end

  add_index "field_data_field_hidden", ["bundle"], :name => "bundle"
  add_index "field_data_field_hidden", ["deleted"], :name => "deleted"
  add_index "field_data_field_hidden", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_hidden", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_hidden", ["field_hidden_value"], :name => "field_hidden_value"
  add_index "field_data_field_hidden", ["language"], :name => "language"
  add_index "field_data_field_hidden", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_icon", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128,  :default => "", :null => false
    t.string  "bundle",            :limit => 128,  :default => "", :null => false
    t.integer "deleted",           :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id"
    t.string  "language",          :limit => 32,   :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.integer "field_icon_fid"
    t.string  "field_icon_alt",    :limit => 512
    t.string  "field_icon_title",  :limit => 1024
    t.integer "field_icon_width"
    t.integer "field_icon_height"
  end

  add_index "field_data_field_icon", ["bundle"], :name => "bundle"
  add_index "field_data_field_icon", ["deleted"], :name => "deleted"
  add_index "field_data_field_icon", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_icon", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_icon", ["field_icon_fid"], :name => "field_icon_fid"
  add_index "field_data_field_icon", ["language"], :name => "language"
  add_index "field_data_field_icon", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_image", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128,  :default => "", :null => false
    t.string  "bundle",             :limit => 128,  :default => "", :null => false
    t.integer "deleted",            :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",           :limit => 32,   :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_image_fid"
    t.string  "field_image_alt",    :limit => 512
    t.string  "field_image_title",  :limit => 1024
    t.integer "field_image_width"
    t.integer "field_image_height"
  end

  add_index "field_data_field_image", ["bundle"], :name => "bundle"
  add_index "field_data_field_image", ["deleted"], :name => "deleted"
  add_index "field_data_field_image", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_image", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_image", ["field_image_fid"], :name => "field_image_fid"
  add_index "field_data_field_image", ["language"], :name => "language"
  add_index "field_data_field_image", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_indie", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id"
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.integer "field_indie_value"
  end

  add_index "field_data_field_indie", ["bundle"], :name => "bundle"
  add_index "field_data_field_indie", ["deleted"], :name => "deleted"
  add_index "field_data_field_indie", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_indie", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_indie", ["field_indie_value"], :name => "field_indie_value"
  add_index "field_data_field_indie", ["language"], :name => "language"
  add_index "field_data_field_indie", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_keyword", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_keyword_value"
    t.string  "field_keyword_format"
  end

  add_index "field_data_field_keyword", ["bundle"], :name => "bundle"
  add_index "field_data_field_keyword", ["deleted"], :name => "deleted"
  add_index "field_data_field_keyword", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_keyword", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_keyword", ["field_keyword_format"], :name => "field_keyword_format"
  add_index "field_data_field_keyword", ["language"], :name => "language"
  add_index "field_data_field_keyword", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_language", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_language_value"
  end

  add_index "field_data_field_language", ["bundle"], :name => "bundle"
  add_index "field_data_field_language", ["deleted"], :name => "deleted"
  add_index "field_data_field_language", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_language", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_language", ["field_language_value"], :name => "field_language_value"
  add_index "field_data_field_language", ["language"], :name => "language"
  add_index "field_data_field_language", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_link", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128,  :default => "", :null => false
    t.string  "bundle",            :limit => 128,  :default => "", :null => false
    t.integer "deleted",           :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id"
    t.string  "language",          :limit => 32,   :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_link_value",  :limit => 1024
    t.string  "field_link_format"
  end

  add_index "field_data_field_link", ["bundle"], :name => "bundle"
  add_index "field_data_field_link", ["deleted"], :name => "deleted"
  add_index "field_data_field_link", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_link", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_link", ["field_link_format"], :name => "field_link_format"
  add_index "field_data_field_link", ["language"], :name => "language"
  add_index "field_data_field_link", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_manual", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128, :default => "", :null => false
    t.string  "bundle",                   :limit => 128, :default => "", :null => false
    t.integer "deleted",                  :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id"
    t.string  "language",                 :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "field_manual_fid"
    t.integer "field_manual_display",     :limit => 1,   :default => 1,  :null => false
    t.text    "field_manual_description"
  end

  add_index "field_data_field_manual", ["bundle"], :name => "bundle"
  add_index "field_data_field_manual", ["deleted"], :name => "deleted"
  add_index "field_data_field_manual", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_manual", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_manual", ["field_manual_fid"], :name => "field_manual_fid"
  add_index "field_data_field_manual", ["language"], :name => "language"
  add_index "field_data_field_manual", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_min_age", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_min_age_value"
  end

  add_index "field_data_field_min_age", ["bundle"], :name => "bundle"
  add_index "field_data_field_min_age", ["deleted"], :name => "deleted"
  add_index "field_data_field_min_age", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_min_age", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_min_age", ["language"], :name => "language"
  add_index "field_data_field_min_age", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_news_tag", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_news_tag_value"
  end

  add_index "field_data_field_news_tag", ["bundle"], :name => "bundle"
  add_index "field_data_field_news_tag", ["deleted"], :name => "deleted"
  add_index "field_data_field_news_tag", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_news_tag", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_news_tag", ["field_news_tag_value"], :name => "field_news_tag_value"
  add_index "field_data_field_news_tag", ["language"], :name => "language"
  add_index "field_data_field_news_tag", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_onlinetype", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id"
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.integer "field_onlinetype_tid"
  end

  add_index "field_data_field_onlinetype", ["bundle"], :name => "bundle"
  add_index "field_data_field_onlinetype", ["deleted"], :name => "deleted"
  add_index "field_data_field_onlinetype", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_onlinetype", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_onlinetype", ["field_onlinetype_tid"], :name => "field_onlinetype_tid"
  add_index "field_data_field_onlinetype", ["language"], :name => "language"
  add_index "field_data_field_onlinetype", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_product_img", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128,  :default => "", :null => false
    t.string  "bundle",                   :limit => 128,  :default => "", :null => false
    t.integer "deleted",                  :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                                :null => false
    t.integer "revision_id"
    t.string  "language",                 :limit => 32,   :default => "", :null => false
    t.integer "delta",                                                    :null => false
    t.integer "field_product_img_fid"
    t.string  "field_product_img_alt",    :limit => 512
    t.string  "field_product_img_title",  :limit => 1024
    t.integer "field_product_img_width"
    t.integer "field_product_img_height"
  end

  add_index "field_data_field_product_img", ["bundle"], :name => "bundle"
  add_index "field_data_field_product_img", ["deleted"], :name => "deleted"
  add_index "field_data_field_product_img", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_product_img", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_product_img", ["field_product_img_fid"], :name => "field_product_img_fid"
  add_index "field_data_field_product_img", ["language"], :name => "language"
  add_index "field_data_field_product_img", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_product_tag", :id => false, :force => true do |t|
    t.string  "entity_type",           :limit => 128, :default => "", :null => false
    t.string  "bundle",                :limit => 128, :default => "", :null => false
    t.integer "deleted",               :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                            :null => false
    t.integer "revision_id"
    t.string  "language",              :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                :null => false
    t.integer "field_product_tag_tid"
  end

  add_index "field_data_field_product_tag", ["bundle"], :name => "bundle"
  add_index "field_data_field_product_tag", ["deleted"], :name => "deleted"
  add_index "field_data_field_product_tag", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_product_tag", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_product_tag", ["field_product_tag_tid"], :name => "field_product_tag_tid"
  add_index "field_data_field_product_tag", ["language"], :name => "language"
  add_index "field_data_field_product_tag", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_publisher", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_publisher_tid"
  end

  add_index "field_data_field_publisher", ["bundle"], :name => "bundle"
  add_index "field_data_field_publisher", ["deleted"], :name => "deleted"
  add_index "field_data_field_publisher", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_publisher", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_publisher", ["field_publisher_tid"], :name => "field_publisher_tid"
  add_index "field_data_field_publisher", ["language"], :name => "language"
  add_index "field_data_field_publisher", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_pubtype", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id"
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.string  "field_pubtype_value"
  end

  add_index "field_data_field_pubtype", ["bundle"], :name => "bundle"
  add_index "field_data_field_pubtype", ["deleted"], :name => "deleted"
  add_index "field_data_field_pubtype", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_pubtype", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_pubtype", ["field_pubtype_value"], :name => "field_pubtype_value"
  add_index "field_data_field_pubtype", ["language"], :name => "language"
  add_index "field_data_field_pubtype", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_rating", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128,                                :default => "", :null => false
    t.string  "bundle",             :limit => 128,                                :default => "", :null => false
    t.integer "deleted",            :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                        :null => false
    t.integer "revision_id"
    t.string  "language",           :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                            :null => false
    t.decimal "field_rating_value",                :precision => 10, :scale => 1
  end

  add_index "field_data_field_rating", ["bundle"], :name => "bundle"
  add_index "field_data_field_rating", ["deleted"], :name => "deleted"
  add_index "field_data_field_rating", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_rating", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_rating", ["language"], :name => "language"
  add_index "field_data_field_rating", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_release_date", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128, :default => "", :null => false
    t.string  "bundle",                   :limit => 128, :default => "", :null => false
    t.integer "deleted",                  :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id"
    t.string  "language",                 :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "field_release_date_value"
  end

  add_index "field_data_field_release_date", ["bundle"], :name => "bundle"
  add_index "field_data_field_release_date", ["deleted"], :name => "deleted"
  add_index "field_data_field_release_date", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_release_date", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_release_date", ["language"], :name => "language"
  add_index "field_data_field_release_date", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_sale_hint", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128,        :default => "", :null => false
    t.string  "bundle",                 :limit => 128,        :default => "", :null => false
    t.integer "deleted",                :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                    :null => false
    t.integer "revision_id"
    t.string  "language",               :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                        :null => false
    t.text    "field_sale_hint_value",  :limit => 2147483647
    t.string  "field_sale_hint_format"
  end

  add_index "field_data_field_sale_hint", ["bundle"], :name => "bundle"
  add_index "field_data_field_sale_hint", ["deleted"], :name => "deleted"
  add_index "field_data_field_sale_hint", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_sale_hint", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_sale_hint", ["field_sale_hint_format"], :name => "field_sale_hint_format"
  add_index "field_data_field_sale_hint", ["language"], :name => "language"
  add_index "field_data_field_sale_hint", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_sale_link", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128, :default => "", :null => false
    t.string  "bundle",                 :limit => 128, :default => "", :null => false
    t.integer "deleted",                :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                             :null => false
    t.integer "revision_id"
    t.string  "language",               :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                 :null => false
    t.string  "field_sale_link_value"
    t.string  "field_sale_link_format"
  end

  add_index "field_data_field_sale_link", ["bundle"], :name => "bundle"
  add_index "field_data_field_sale_link", ["deleted"], :name => "deleted"
  add_index "field_data_field_sale_link", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_sale_link", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_sale_link", ["field_sale_link_format"], :name => "field_sale_link_format"
  add_index "field_data_field_sale_link", ["language"], :name => "language"
  add_index "field_data_field_sale_link", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_shortname", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128, :default => "", :null => false
    t.string  "bundle",                 :limit => 128, :default => "", :null => false
    t.integer "deleted",                :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                             :null => false
    t.integer "revision_id"
    t.string  "language",               :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                 :null => false
    t.string  "field_shortname_value"
    t.string  "field_shortname_format"
  end

  add_index "field_data_field_shortname", ["bundle"], :name => "bundle"
  add_index "field_data_field_shortname", ["deleted"], :name => "deleted"
  add_index "field_data_field_shortname", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_shortname", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_shortname", ["field_shortname_format"], :name => "field_shortname_format"
  add_index "field_data_field_shortname", ["language"], :name => "language"
  add_index "field_data_field_shortname", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_tags", :id => false, :force => true do |t|
    t.string  "entity_type",    :limit => 128, :default => "", :null => false
    t.string  "bundle",         :limit => 128, :default => "", :null => false
    t.integer "deleted",        :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                     :null => false
    t.integer "revision_id"
    t.string  "language",       :limit => 32,  :default => "", :null => false
    t.integer "delta",                                         :null => false
    t.integer "field_tags_tid"
  end

  add_index "field_data_field_tags", ["bundle"], :name => "bundle"
  add_index "field_data_field_tags", ["deleted"], :name => "deleted"
  add_index "field_data_field_tags", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_tags", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_tags", ["field_tags_tid"], :name => "field_tags_tid"
  add_index "field_data_field_tags", ["language"], :name => "language"
  add_index "field_data_field_tags", ["revision_id"], :name => "revision_id"

  create_table "field_data_field_video", :id => false, :force => true do |t|
    t.string  "entity_type",           :limit => 128, :default => "", :null => false
    t.string  "bundle",                :limit => 128, :default => "", :null => false
    t.integer "deleted",               :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                            :null => false
    t.integer "revision_id"
    t.string  "language",              :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                :null => false
    t.integer "field_video_fid"
    t.integer "field_video_thumbnail"
  end

  add_index "field_data_field_video", ["bundle"], :name => "bundle"
  add_index "field_data_field_video", ["deleted"], :name => "deleted"
  add_index "field_data_field_video", ["entity_id"], :name => "entity_id"
  add_index "field_data_field_video", ["entity_type"], :name => "entity_type"
  add_index "field_data_field_video", ["field_video_fid"], :name => "field_video_fid"
  add_index "field_data_field_video", ["language"], :name => "language"
  add_index "field_data_field_video", ["revision_id"], :name => "revision_id"

  create_table "field_data_uc_product_image", :id => false, :force => true do |t|
    t.string  "entity_type",             :limit => 128,  :default => "", :null => false
    t.string  "bundle",                  :limit => 128,  :default => "", :null => false
    t.integer "deleted",                 :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id"
    t.string  "language",                :limit => 32,   :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "uc_product_image_fid"
    t.string  "uc_product_image_alt",    :limit => 512
    t.string  "uc_product_image_title",  :limit => 1024
    t.integer "uc_product_image_width"
    t.integer "uc_product_image_height"
  end

  add_index "field_data_uc_product_image", ["bundle"], :name => "bundle"
  add_index "field_data_uc_product_image", ["deleted"], :name => "deleted"
  add_index "field_data_uc_product_image", ["entity_id"], :name => "entity_id"
  add_index "field_data_uc_product_image", ["entity_type"], :name => "entity_type"
  add_index "field_data_uc_product_image", ["language"], :name => "language"
  add_index "field_data_uc_product_image", ["revision_id"], :name => "revision_id"
  add_index "field_data_uc_product_image", ["uc_product_image_fid"], :name => "uc_product_image_fid"

  create_table "field_revision_body", :id => false, :force => true do |t|
    t.string  "entity_type",  :limit => 128,        :default => "", :null => false
    t.string  "bundle",       :limit => 128,        :default => "", :null => false
    t.integer "deleted",      :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",     :limit => 32,         :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.text    "body_value",   :limit => 2147483647
    t.text    "body_summary", :limit => 2147483647
    t.string  "body_format"
  end

  add_index "field_revision_body", ["body_format"], :name => "body_format"
  add_index "field_revision_body", ["bundle"], :name => "bundle"
  add_index "field_revision_body", ["deleted"], :name => "deleted"
  add_index "field_revision_body", ["entity_id"], :name => "entity_id"
  add_index "field_revision_body", ["entity_type"], :name => "entity_type"
  add_index "field_revision_body", ["language"], :name => "language"
  add_index "field_revision_body", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_alias", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id",                                       :null => false
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_alias_value"
    t.string  "field_alias_format"
  end

  add_index "field_revision_field_alias", ["bundle"], :name => "bundle"
  add_index "field_revision_field_alias", ["deleted"], :name => "deleted"
  add_index "field_revision_field_alias", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_alias", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_alias", ["field_alias_format"], :name => "field_alias_format"
  add_index "field_revision_field_alias", ["language"], :name => "language"
  add_index "field_revision_field_alias", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_attachment", :id => false, :force => true do |t|
    t.string  "entity_type",                  :limit => 128, :default => "", :null => false
    t.string  "bundle",                       :limit => 128, :default => "", :null => false
    t.integer "deleted",                      :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                   :null => false
    t.integer "revision_id",                                                 :null => false
    t.string  "language",                     :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                       :null => false
    t.integer "field_attachment_fid"
    t.integer "field_attachment_display",     :limit => 1,   :default => 1,  :null => false
    t.text    "field_attachment_description"
  end

  add_index "field_revision_field_attachment", ["bundle"], :name => "bundle"
  add_index "field_revision_field_attachment", ["deleted"], :name => "deleted"
  add_index "field_revision_field_attachment", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_attachment", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_attachment", ["field_attachment_fid"], :name => "field_attachment_fid"
  add_index "field_revision_field_attachment", ["language"], :name => "language"
  add_index "field_revision_field_attachment", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_copyright", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128,        :default => "", :null => false
    t.string  "bundle",                 :limit => 128,        :default => "", :null => false
    t.integer "deleted",                :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                    :null => false
    t.integer "revision_id",                                                  :null => false
    t.string  "language",               :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                        :null => false
    t.text    "field_copyright_value",  :limit => 2147483647
    t.string  "field_copyright_format"
  end

  add_index "field_revision_field_copyright", ["bundle"], :name => "bundle"
  add_index "field_revision_field_copyright", ["deleted"], :name => "deleted"
  add_index "field_revision_field_copyright", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_copyright", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_copyright", ["field_copyright_format"], :name => "field_copyright_format"
  add_index "field_revision_field_copyright", ["language"], :name => "language"
  add_index "field_revision_field_copyright", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_desc", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id",                                      :null => false
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.string  "field_desc_value"
    t.string  "field_desc_format"
  end

  add_index "field_revision_field_desc", ["bundle"], :name => "bundle"
  add_index "field_revision_field_desc", ["deleted"], :name => "deleted"
  add_index "field_revision_field_desc", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_desc", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_desc", ["field_desc_format"], :name => "field_desc_format"
  add_index "field_revision_field_desc", ["language"], :name => "language"
  add_index "field_revision_field_desc", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_developer", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_developer_tid"
  end

  add_index "field_revision_field_developer", ["bundle"], :name => "bundle"
  add_index "field_revision_field_developer", ["deleted"], :name => "deleted"
  add_index "field_revision_field_developer", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_developer", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_developer", ["field_developer_tid"], :name => "field_developer_tid"
  add_index "field_revision_field_developer", ["language"], :name => "language"
  add_index "field_revision_field_developer", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_english_name", :id => false, :force => true do |t|
    t.string  "entity_type",               :limit => 128, :default => "", :null => false
    t.string  "bundle",                    :limit => 128, :default => "", :null => false
    t.integer "deleted",                   :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                                :null => false
    t.integer "revision_id",                                              :null => false
    t.string  "language",                  :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                    :null => false
    t.string  "field_english_name_value"
    t.string  "field_english_name_format"
  end

  add_index "field_revision_field_english_name", ["bundle"], :name => "bundle"
  add_index "field_revision_field_english_name", ["deleted"], :name => "deleted"
  add_index "field_revision_field_english_name", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_english_name", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_english_name", ["field_english_name_format"], :name => "field_english_name_format"
  add_index "field_revision_field_english_name", ["language"], :name => "language"
  add_index "field_revision_field_english_name", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_filesize", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128,                                :default => "", :null => false
    t.string  "bundle",               :limit => 128,                                :default => "", :null => false
    t.integer "deleted",              :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                          :null => false
    t.integer "revision_id",                                                                        :null => false
    t.string  "language",             :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                              :null => false
    t.decimal "field_filesize_value",                :precision => 10, :scale => 2
  end

  add_index "field_revision_field_filesize", ["bundle"], :name => "bundle"
  add_index "field_revision_field_filesize", ["deleted"], :name => "deleted"
  add_index "field_revision_field_filesize", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_filesize", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_filesize", ["language"], :name => "language"
  add_index "field_revision_field_filesize", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_forum_addr", :id => false, :force => true do |t|
    t.string  "entity_type",             :limit => 128, :default => "", :null => false
    t.string  "bundle",                  :limit => 128, :default => "", :null => false
    t.integer "deleted",                 :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                              :null => false
    t.integer "revision_id",                                            :null => false
    t.string  "language",                :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                  :null => false
    t.string  "field_forum_addr_value"
    t.string  "field_forum_addr_format"
  end

  add_index "field_revision_field_forum_addr", ["bundle"], :name => "bundle"
  add_index "field_revision_field_forum_addr", ["deleted"], :name => "deleted"
  add_index "field_revision_field_forum_addr", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_forum_addr", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_forum_addr", ["field_forum_addr_format"], :name => "field_forum_addr_format"
  add_index "field_revision_field_forum_addr", ["language"], :name => "language"
  add_index "field_revision_field_forum_addr", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_game", :id => false, :force => true do |t|
    t.string  "entity_type",    :limit => 128, :default => "", :null => false
    t.string  "bundle",         :limit => 128, :default => "", :null => false
    t.integer "deleted",        :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                     :null => false
    t.integer "revision_id",                                   :null => false
    t.string  "language",       :limit => 32,  :default => "", :null => false
    t.integer "delta",                                         :null => false
    t.integer "field_game_nid"
  end

  add_index "field_revision_field_game", ["bundle"], :name => "bundle"
  add_index "field_revision_field_game", ["deleted"], :name => "deleted"
  add_index "field_revision_field_game", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_game", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_game", ["field_game_nid"], :name => "field_game_nid"
  add_index "field_revision_field_game", ["language"], :name => "language"
  add_index "field_revision_field_game", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_game_tag", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id",                                         :null => false
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_game_tag_value"
  end

  add_index "field_revision_field_game_tag", ["bundle"], :name => "bundle"
  add_index "field_revision_field_game_tag", ["deleted"], :name => "deleted"
  add_index "field_revision_field_game_tag", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_game_tag", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_game_tag", ["field_game_tag_value"], :name => "field_game_tag_value"
  add_index "field_revision_field_game_tag", ["language"], :name => "language"
  add_index "field_revision_field_game_tag", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_genera", :id => false, :force => true do |t|
    t.string  "entity_type",      :limit => 128, :default => "", :null => false
    t.string  "bundle",           :limit => 128, :default => "", :null => false
    t.integer "deleted",          :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                       :null => false
    t.integer "revision_id",                                     :null => false
    t.string  "language",         :limit => 32,  :default => "", :null => false
    t.integer "delta",                                           :null => false
    t.integer "field_genera_tid"
  end

  add_index "field_revision_field_genera", ["bundle"], :name => "bundle"
  add_index "field_revision_field_genera", ["deleted"], :name => "deleted"
  add_index "field_revision_field_genera", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_genera", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_genera", ["field_genera_tid"], :name => "field_genera_tid"
  add_index "field_revision_field_genera", ["language"], :name => "language"
  add_index "field_revision_field_genera", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_hidden", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128, :default => "", :null => false
    t.string  "bundle",             :limit => 128, :default => "", :null => false
    t.integer "deleted",            :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id",                                       :null => false
    t.string  "language",           :limit => 32,  :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.integer "field_hidden_value"
  end

  add_index "field_revision_field_hidden", ["bundle"], :name => "bundle"
  add_index "field_revision_field_hidden", ["deleted"], :name => "deleted"
  add_index "field_revision_field_hidden", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_hidden", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_hidden", ["field_hidden_value"], :name => "field_hidden_value"
  add_index "field_revision_field_hidden", ["language"], :name => "language"
  add_index "field_revision_field_hidden", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_icon", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128,  :default => "", :null => false
    t.string  "bundle",            :limit => 128,  :default => "", :null => false
    t.integer "deleted",           :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id",                                       :null => false
    t.string  "language",          :limit => 32,   :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.integer "field_icon_fid"
    t.string  "field_icon_alt",    :limit => 512
    t.string  "field_icon_title",  :limit => 1024
    t.integer "field_icon_width"
    t.integer "field_icon_height"
  end

  add_index "field_revision_field_icon", ["bundle"], :name => "bundle"
  add_index "field_revision_field_icon", ["deleted"], :name => "deleted"
  add_index "field_revision_field_icon", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_icon", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_icon", ["field_icon_fid"], :name => "field_icon_fid"
  add_index "field_revision_field_icon", ["language"], :name => "language"
  add_index "field_revision_field_icon", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_image", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128,  :default => "", :null => false
    t.string  "bundle",             :limit => 128,  :default => "", :null => false
    t.integer "deleted",            :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",           :limit => 32,   :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_image_fid"
    t.string  "field_image_alt",    :limit => 512
    t.string  "field_image_title",  :limit => 1024
    t.integer "field_image_width"
    t.integer "field_image_height"
  end

  add_index "field_revision_field_image", ["bundle"], :name => "bundle"
  add_index "field_revision_field_image", ["deleted"], :name => "deleted"
  add_index "field_revision_field_image", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_image", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_image", ["field_image_fid"], :name => "field_image_fid"
  add_index "field_revision_field_image", ["language"], :name => "language"
  add_index "field_revision_field_image", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_indie", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128, :default => "", :null => false
    t.string  "bundle",            :limit => 128, :default => "", :null => false
    t.integer "deleted",           :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                        :null => false
    t.integer "revision_id",                                      :null => false
    t.string  "language",          :limit => 32,  :default => "", :null => false
    t.integer "delta",                                            :null => false
    t.integer "field_indie_value"
  end

  add_index "field_revision_field_indie", ["bundle"], :name => "bundle"
  add_index "field_revision_field_indie", ["deleted"], :name => "deleted"
  add_index "field_revision_field_indie", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_indie", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_indie", ["field_indie_value"], :name => "field_indie_value"
  add_index "field_revision_field_indie", ["language"], :name => "language"
  add_index "field_revision_field_indie", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_keyword", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id",                                         :null => false
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_keyword_value"
    t.string  "field_keyword_format"
  end

  add_index "field_revision_field_keyword", ["bundle"], :name => "bundle"
  add_index "field_revision_field_keyword", ["deleted"], :name => "deleted"
  add_index "field_revision_field_keyword", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_keyword", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_keyword", ["field_keyword_format"], :name => "field_keyword_format"
  add_index "field_revision_field_keyword", ["language"], :name => "language"
  add_index "field_revision_field_keyword", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_language", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id",                                         :null => false
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_language_value"
  end

  add_index "field_revision_field_language", ["bundle"], :name => "bundle"
  add_index "field_revision_field_language", ["deleted"], :name => "deleted"
  add_index "field_revision_field_language", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_language", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_language", ["field_language_value"], :name => "field_language_value"
  add_index "field_revision_field_language", ["language"], :name => "language"
  add_index "field_revision_field_language", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_link", :id => false, :force => true do |t|
    t.string  "entity_type",       :limit => 128,  :default => "", :null => false
    t.string  "bundle",            :limit => 128,  :default => "", :null => false
    t.integer "deleted",           :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                         :null => false
    t.integer "revision_id",                                       :null => false
    t.string  "language",          :limit => 32,   :default => "", :null => false
    t.integer "delta",                                             :null => false
    t.string  "field_link_value",  :limit => 1024
    t.string  "field_link_format"
  end

  add_index "field_revision_field_link", ["bundle"], :name => "bundle"
  add_index "field_revision_field_link", ["deleted"], :name => "deleted"
  add_index "field_revision_field_link", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_link", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_link", ["field_link_format"], :name => "field_link_format"
  add_index "field_revision_field_link", ["language"], :name => "language"
  add_index "field_revision_field_link", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_manual", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128, :default => "", :null => false
    t.string  "bundle",                   :limit => 128, :default => "", :null => false
    t.integer "deleted",                  :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id",                                             :null => false
    t.string  "language",                 :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "field_manual_fid"
    t.integer "field_manual_display",     :limit => 1,   :default => 1,  :null => false
    t.text    "field_manual_description"
  end

  add_index "field_revision_field_manual", ["bundle"], :name => "bundle"
  add_index "field_revision_field_manual", ["deleted"], :name => "deleted"
  add_index "field_revision_field_manual", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_manual", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_manual", ["field_manual_fid"], :name => "field_manual_fid"
  add_index "field_revision_field_manual", ["language"], :name => "language"
  add_index "field_revision_field_manual", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_min_age", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_min_age_value"
  end

  add_index "field_revision_field_min_age", ["bundle"], :name => "bundle"
  add_index "field_revision_field_min_age", ["deleted"], :name => "deleted"
  add_index "field_revision_field_min_age", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_min_age", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_min_age", ["language"], :name => "language"
  add_index "field_revision_field_min_age", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_news_tag", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id",                                         :null => false
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.string  "field_news_tag_value"
  end

  add_index "field_revision_field_news_tag", ["bundle"], :name => "bundle"
  add_index "field_revision_field_news_tag", ["deleted"], :name => "deleted"
  add_index "field_revision_field_news_tag", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_news_tag", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_news_tag", ["field_news_tag_value"], :name => "field_news_tag_value"
  add_index "field_revision_field_news_tag", ["language"], :name => "language"
  add_index "field_revision_field_news_tag", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_onlinetype", :id => false, :force => true do |t|
    t.string  "entity_type",          :limit => 128, :default => "", :null => false
    t.string  "bundle",               :limit => 128, :default => "", :null => false
    t.integer "deleted",              :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                           :null => false
    t.integer "revision_id",                                         :null => false
    t.string  "language",             :limit => 32,  :default => "", :null => false
    t.integer "delta",                                               :null => false
    t.integer "field_onlinetype_tid"
  end

  add_index "field_revision_field_onlinetype", ["bundle"], :name => "bundle"
  add_index "field_revision_field_onlinetype", ["deleted"], :name => "deleted"
  add_index "field_revision_field_onlinetype", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_onlinetype", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_onlinetype", ["field_onlinetype_tid"], :name => "field_onlinetype_tid"
  add_index "field_revision_field_onlinetype", ["language"], :name => "language"
  add_index "field_revision_field_onlinetype", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_product_img", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128,  :default => "", :null => false
    t.string  "bundle",                   :limit => 128,  :default => "", :null => false
    t.integer "deleted",                  :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                                :null => false
    t.integer "revision_id",                                              :null => false
    t.string  "language",                 :limit => 32,   :default => "", :null => false
    t.integer "delta",                                                    :null => false
    t.integer "field_product_img_fid"
    t.string  "field_product_img_alt",    :limit => 512
    t.string  "field_product_img_title",  :limit => 1024
    t.integer "field_product_img_width"
    t.integer "field_product_img_height"
  end

  add_index "field_revision_field_product_img", ["bundle"], :name => "bundle"
  add_index "field_revision_field_product_img", ["deleted"], :name => "deleted"
  add_index "field_revision_field_product_img", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_product_img", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_product_img", ["field_product_img_fid"], :name => "field_product_img_fid"
  add_index "field_revision_field_product_img", ["language"], :name => "language"
  add_index "field_revision_field_product_img", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_product_tag", :id => false, :force => true do |t|
    t.string  "entity_type",           :limit => 128, :default => "", :null => false
    t.string  "bundle",                :limit => 128, :default => "", :null => false
    t.integer "deleted",               :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                            :null => false
    t.integer "revision_id",                                          :null => false
    t.string  "language",              :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                :null => false
    t.integer "field_product_tag_tid"
  end

  add_index "field_revision_field_product_tag", ["bundle"], :name => "bundle"
  add_index "field_revision_field_product_tag", ["deleted"], :name => "deleted"
  add_index "field_revision_field_product_tag", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_product_tag", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_product_tag", ["field_product_tag_tid"], :name => "field_product_tag_tid"
  add_index "field_revision_field_product_tag", ["language"], :name => "language"
  add_index "field_revision_field_product_tag", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_publisher", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.integer "field_publisher_tid"
  end

  add_index "field_revision_field_publisher", ["bundle"], :name => "bundle"
  add_index "field_revision_field_publisher", ["deleted"], :name => "deleted"
  add_index "field_revision_field_publisher", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_publisher", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_publisher", ["field_publisher_tid"], :name => "field_publisher_tid"
  add_index "field_revision_field_publisher", ["language"], :name => "language"
  add_index "field_revision_field_publisher", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_pubtype", :id => false, :force => true do |t|
    t.string  "entity_type",         :limit => 128, :default => "", :null => false
    t.string  "bundle",              :limit => 128, :default => "", :null => false
    t.integer "deleted",             :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                          :null => false
    t.integer "revision_id",                                        :null => false
    t.string  "language",            :limit => 32,  :default => "", :null => false
    t.integer "delta",                                              :null => false
    t.string  "field_pubtype_value"
  end

  add_index "field_revision_field_pubtype", ["bundle"], :name => "bundle"
  add_index "field_revision_field_pubtype", ["deleted"], :name => "deleted"
  add_index "field_revision_field_pubtype", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_pubtype", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_pubtype", ["field_pubtype_value"], :name => "field_pubtype_value"
  add_index "field_revision_field_pubtype", ["language"], :name => "language"
  add_index "field_revision_field_pubtype", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_rating", :id => false, :force => true do |t|
    t.string  "entity_type",        :limit => 128,                                :default => "", :null => false
    t.string  "bundle",             :limit => 128,                                :default => "", :null => false
    t.integer "deleted",            :limit => 1,                                  :default => 0,  :null => false
    t.integer "entity_id",                                                                        :null => false
    t.integer "revision_id",                                                                      :null => false
    t.string  "language",           :limit => 32,                                 :default => "", :null => false
    t.integer "delta",                                                                            :null => false
    t.decimal "field_rating_value",                :precision => 10, :scale => 1
  end

  add_index "field_revision_field_rating", ["bundle"], :name => "bundle"
  add_index "field_revision_field_rating", ["deleted"], :name => "deleted"
  add_index "field_revision_field_rating", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_rating", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_rating", ["language"], :name => "language"
  add_index "field_revision_field_rating", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_release_date", :id => false, :force => true do |t|
    t.string  "entity_type",              :limit => 128, :default => "", :null => false
    t.string  "bundle",                   :limit => 128, :default => "", :null => false
    t.integer "deleted",                  :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id",                                             :null => false
    t.string  "language",                 :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "field_release_date_value"
  end

  add_index "field_revision_field_release_date", ["bundle"], :name => "bundle"
  add_index "field_revision_field_release_date", ["deleted"], :name => "deleted"
  add_index "field_revision_field_release_date", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_release_date", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_release_date", ["language"], :name => "language"
  add_index "field_revision_field_release_date", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_sale_hint", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128,        :default => "", :null => false
    t.string  "bundle",                 :limit => 128,        :default => "", :null => false
    t.integer "deleted",                :limit => 1,          :default => 0,  :null => false
    t.integer "entity_id",                                                    :null => false
    t.integer "revision_id",                                                  :null => false
    t.string  "language",               :limit => 32,         :default => "", :null => false
    t.integer "delta",                                                        :null => false
    t.text    "field_sale_hint_value",  :limit => 2147483647
    t.string  "field_sale_hint_format"
  end

  add_index "field_revision_field_sale_hint", ["bundle"], :name => "bundle"
  add_index "field_revision_field_sale_hint", ["deleted"], :name => "deleted"
  add_index "field_revision_field_sale_hint", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_sale_hint", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_sale_hint", ["field_sale_hint_format"], :name => "field_sale_hint_format"
  add_index "field_revision_field_sale_hint", ["language"], :name => "language"
  add_index "field_revision_field_sale_hint", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_sale_link", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128, :default => "", :null => false
    t.string  "bundle",                 :limit => 128, :default => "", :null => false
    t.integer "deleted",                :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                             :null => false
    t.integer "revision_id",                                           :null => false
    t.string  "language",               :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                 :null => false
    t.string  "field_sale_link_value"
    t.string  "field_sale_link_format"
  end

  add_index "field_revision_field_sale_link", ["bundle"], :name => "bundle"
  add_index "field_revision_field_sale_link", ["deleted"], :name => "deleted"
  add_index "field_revision_field_sale_link", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_sale_link", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_sale_link", ["field_sale_link_format"], :name => "field_sale_link_format"
  add_index "field_revision_field_sale_link", ["language"], :name => "language"
  add_index "field_revision_field_sale_link", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_shortname", :id => false, :force => true do |t|
    t.string  "entity_type",            :limit => 128, :default => "", :null => false
    t.string  "bundle",                 :limit => 128, :default => "", :null => false
    t.integer "deleted",                :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                             :null => false
    t.integer "revision_id",                                           :null => false
    t.string  "language",               :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                 :null => false
    t.string  "field_shortname_value"
    t.string  "field_shortname_format"
  end

  add_index "field_revision_field_shortname", ["bundle"], :name => "bundle"
  add_index "field_revision_field_shortname", ["deleted"], :name => "deleted"
  add_index "field_revision_field_shortname", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_shortname", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_shortname", ["field_shortname_format"], :name => "field_shortname_format"
  add_index "field_revision_field_shortname", ["language"], :name => "language"
  add_index "field_revision_field_shortname", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_tags", :id => false, :force => true do |t|
    t.string  "entity_type",    :limit => 128, :default => "", :null => false
    t.string  "bundle",         :limit => 128, :default => "", :null => false
    t.integer "deleted",        :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                     :null => false
    t.integer "revision_id",                                   :null => false
    t.string  "language",       :limit => 32,  :default => "", :null => false
    t.integer "delta",                                         :null => false
    t.integer "field_tags_tid"
  end

  add_index "field_revision_field_tags", ["bundle"], :name => "bundle"
  add_index "field_revision_field_tags", ["deleted"], :name => "deleted"
  add_index "field_revision_field_tags", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_tags", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_tags", ["field_tags_tid"], :name => "field_tags_tid"
  add_index "field_revision_field_tags", ["language"], :name => "language"
  add_index "field_revision_field_tags", ["revision_id"], :name => "revision_id"

  create_table "field_revision_field_video", :id => false, :force => true do |t|
    t.string  "entity_type",           :limit => 128, :default => "", :null => false
    t.string  "bundle",                :limit => 128, :default => "", :null => false
    t.integer "deleted",               :limit => 1,   :default => 0,  :null => false
    t.integer "entity_id",                                            :null => false
    t.integer "revision_id",                                          :null => false
    t.string  "language",              :limit => 32,  :default => "", :null => false
    t.integer "delta",                                                :null => false
    t.integer "field_video_fid"
    t.integer "field_video_thumbnail"
  end

  add_index "field_revision_field_video", ["bundle"], :name => "bundle"
  add_index "field_revision_field_video", ["deleted"], :name => "deleted"
  add_index "field_revision_field_video", ["entity_id"], :name => "entity_id"
  add_index "field_revision_field_video", ["entity_type"], :name => "entity_type"
  add_index "field_revision_field_video", ["field_video_fid"], :name => "field_video_fid"
  add_index "field_revision_field_video", ["language"], :name => "language"
  add_index "field_revision_field_video", ["revision_id"], :name => "revision_id"

  create_table "field_revision_uc_product_image", :id => false, :force => true do |t|
    t.string  "entity_type",             :limit => 128,  :default => "", :null => false
    t.string  "bundle",                  :limit => 128,  :default => "", :null => false
    t.integer "deleted",                 :limit => 1,    :default => 0,  :null => false
    t.integer "entity_id",                                               :null => false
    t.integer "revision_id",                                             :null => false
    t.string  "language",                :limit => 32,   :default => "", :null => false
    t.integer "delta",                                                   :null => false
    t.integer "uc_product_image_fid"
    t.string  "uc_product_image_alt",    :limit => 512
    t.string  "uc_product_image_title",  :limit => 1024
    t.integer "uc_product_image_width"
    t.integer "uc_product_image_height"
  end

  add_index "field_revision_uc_product_image", ["bundle"], :name => "bundle"
  add_index "field_revision_uc_product_image", ["deleted"], :name => "deleted"
  add_index "field_revision_uc_product_image", ["entity_id"], :name => "entity_id"
  add_index "field_revision_uc_product_image", ["entity_type"], :name => "entity_type"
  add_index "field_revision_uc_product_image", ["language"], :name => "language"
  add_index "field_revision_uc_product_image", ["revision_id"], :name => "revision_id"
  add_index "field_revision_uc_product_image", ["uc_product_image_fid"], :name => "uc_product_image_fid"

  create_table "file_managed", :primary_key => "fid", :force => true do |t|
    t.integer "uid",                    :default => 0,  :null => false
    t.string  "filename",               :default => "", :null => false
    t.string  "uri",                    :default => "", :null => false
    t.string  "filemime",               :default => "", :null => false
    t.integer "filesize",               :default => 0,  :null => false
    t.integer "status",    :limit => 1, :default => 0,  :null => false
    t.integer "timestamp",              :default => 0,  :null => false
  end

  add_index "file_managed", ["status"], :name => "status"
  add_index "file_managed", ["timestamp"], :name => "timestamp"
  add_index "file_managed", ["uid"], :name => "uid"
  add_index "file_managed", ["uri"], :name => "uri", :unique => true

  create_table "file_usage", :id => false, :force => true do |t|
    t.integer "fid",                                  :null => false
    t.string  "module",               :default => "", :null => false
    t.string  "type",   :limit => 64, :default => "", :null => false
    t.integer "id",                   :default => 0,  :null => false
    t.integer "count",                :default => 0,  :null => false
  end

  add_index "file_usage", ["fid", "count"], :name => "fid_count"
  add_index "file_usage", ["fid", "module"], :name => "fid_module"
  add_index "file_usage", ["type", "id"], :name => "type_id"

  create_table "filter", :id => false, :force => true do |t|
    t.string  "format",                                         :null => false
    t.string  "module",   :limit => 64,         :default => "", :null => false
    t.string  "name",     :limit => 32,         :default => "", :null => false
    t.integer "weight",                         :default => 0,  :null => false
    t.integer "status",                         :default => 0,  :null => false
    t.binary  "settings", :limit => 2147483647
  end

  add_index "filter", ["weight", "module", "name"], :name => "list"

  create_table "filter_format", :primary_key => "format", :force => true do |t|
    t.string  "name",                :default => "", :null => false
    t.integer "cache",  :limit => 1, :default => 0,  :null => false
    t.integer "status", :limit => 1, :default => 1,  :null => false
    t.integer "weight",              :default => 0,  :null => false
  end

  add_index "filter_format", ["name"], :name => "name", :unique => true
  add_index "filter_format", ["status", "weight"], :name => "status_weight"

  create_table "flood", :primary_key => "fid", :force => true do |t|
    t.string  "event",      :limit => 64,  :default => "", :null => false
    t.string  "identifier", :limit => 128, :default => "", :null => false
    t.integer "timestamp",                 :default => 0,  :null => false
    t.integer "expiration",                :default => 0,  :null => false
  end

  add_index "flood", ["event", "identifier", "timestamp"], :name => "allow"
  add_index "flood", ["expiration"], :name => "purge"

  create_table "friendship", :id => false, :force => true do |t|
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
    t.string   "game_tag",                                                           :null => false
    t.integer  "status",        :limit => 1,                                         :null => false
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.string   "icon_image"
    t.string   "product_image"
    t.decimal  "rating",                              :precision => 10, :scale => 0
    t.string   "forum_addr"
    t.string   "install_type",                                                       :null => false
    t.string   "manual"
    t.integer  "release_date"
    t.string   "link",          :limit => 1024
    t.string   "cap_image"
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

  create_table "groups_accounts", :id => false, :force => true do |t|
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

  create_table "history", :id => false, :force => true do |t|
    t.integer "uid",       :default => 0, :null => false
    t.integer "nid",       :default => 0, :null => false
    t.integer "timestamp", :default => 0, :null => false
  end

  add_index "history", ["nid"], :name => "nid"

  create_table "image_effects", :primary_key => "ieid", :force => true do |t|
    t.integer "isid",                         :default => 0, :null => false
    t.integer "weight",                       :default => 0, :null => false
    t.string  "name",                                        :null => false
    t.binary  "data",   :limit => 2147483647,                :null => false
  end

  add_index "image_effects", ["isid"], :name => "isid"
  add_index "image_effects", ["weight"], :name => "weight"

  create_table "image_styles", :primary_key => "isid", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "image_styles", ["name"], :name => "name", :unique => true

  create_table "languages", :primary_key => "language", :force => true do |t|
    t.string  "name",       :limit => 64,  :default => "", :null => false
    t.string  "native",     :limit => 64,  :default => "", :null => false
    t.integer "direction",                 :default => 0,  :null => false
    t.integer "enabled",                   :default => 0,  :null => false
    t.integer "plurals",                   :default => 0,  :null => false
    t.string  "formula",    :limit => 128, :default => "", :null => false
    t.string  "domain",     :limit => 128, :default => "", :null => false
    t.string  "prefix",     :limit => 128, :default => "", :null => false
    t.integer "weight",                    :default => 0,  :null => false
    t.string  "javascript", :limit => 64,  :default => "", :null => false
  end

  add_index "languages", ["weight", "name"], :name => "list"

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

  create_table "locales_source", :primary_key => "lid", :force => true do |t|
    t.text   "location",  :limit => 2147483647
    t.string "textgroup",                       :default => "default", :null => false
    t.binary "source",                                                 :null => false
    t.string "context",                         :default => "",        :null => false
    t.string "version",   :limit => 20,         :default => "none",    :null => false
  end

  add_index "locales_source", ["source", "context"], :name => "source_context", :length => {"source"=>30, "context"=>nil}

  create_table "locales_target", :id => false, :force => true do |t|
    t.integer "lid",                       :default => 0,  :null => false
    t.binary  "translation",                               :null => false
    t.string  "language",    :limit => 12, :default => "", :null => false
    t.integer "plid",                      :default => 0,  :null => false
    t.integer "plural",                    :default => 0,  :null => false
  end

  add_index "locales_target", ["lid"], :name => "lid"
  add_index "locales_target", ["plid"], :name => "plid"
  add_index "locales_target", ["plural"], :name => "plural"

  create_table "maestro_app_groups", :force => true do |t|
    t.string "app_group", :limit => 100, :null => false
  end

  create_table "maestro_notifications", :id => false, :force => true do |t|
    t.integer "queue_id",                       :default => 0, :null => false
    t.integer "uid",                            :default => 0, :null => false
    t.integer "notification_sent", :limit => 1, :default => 0, :null => false
  end

  add_index "maestro_notifications", ["queue_id"], :name => "queue_id"
  add_index "maestro_notifications", ["uid"], :name => "uid"

  create_table "maestro_process", :force => true do |t|
    t.integer "template_id",    :default => 0,  :null => false
    t.string  "flow_name",      :default => "", :null => false
    t.integer "complete"
    t.integer "initiator_uid"
    t.integer "pid"
    t.integer "initiating_pid", :default => 0
    t.integer "tracking_id"
    t.integer "initiated_date"
    t.integer "completed_date"
  end

  add_index "maestro_process", ["template_id"], :name => "template_id"

  create_table "maestro_process_variables", :force => true do |t|
    t.integer "process_id",           :default => 0,  :null => false
    t.string  "variable_value",       :default => "", :null => false
    t.integer "template_variable_id", :default => 0,  :null => false
  end

  add_index "maestro_process_variables", ["process_id"], :name => "process_id"
  add_index "maestro_process_variables", ["template_variable_id"], :name => "template_variable_id"

  create_table "maestro_production_assignments", :force => true do |t|
    t.integer "task_id",                        :default => 0,  :null => false
    t.integer "assign_type",      :limit => 1,  :default => 0,  :null => false
    t.integer "assign_id",                      :default => 0,  :null => false
    t.integer "process_variable",               :default => 0,  :null => false
    t.integer "assign_back_id",                 :default => 0,  :null => false
    t.integer "last_updated",                   :default => 0,  :null => false
    t.string  "security_hash",    :limit => 64, :default => "", :null => false
  end

  add_index "maestro_production_assignments", ["assign_back_id"], :name => "assign_back_id"
  add_index "maestro_production_assignments", ["process_variable"], :name => "process_variable"
  add_index "maestro_production_assignments", ["task_id"], :name => "task_id"

  create_table "maestro_project_comments", :force => true do |t|
    t.integer "tracking_id",                       :default => 0, :null => false
    t.integer "task_id",                           :default => 0, :null => false
    t.integer "uid",                               :default => 0, :null => false
    t.integer "timestamp",                         :default => 0, :null => false
    t.text    "comment",     :limit => 2147483647,                :null => false
  end

  add_index "maestro_project_comments", ["tracking_id"], :name => "tracking_id"

  create_table "maestro_project_content", :force => true do |t|
    t.integer "nid",                                          :null => false
    t.integer "tracking_id"
    t.integer "task_id"
    t.integer "instance",                      :default => 1, :null => false
    t.string  "content_type",                                 :null => false
    t.text    "task_data"
    t.integer "created_by_uid",                :default => 0, :null => false
    t.integer "is_locked_by_uid",              :default => 0, :null => false
    t.integer "status",           :limit => 1, :default => 0, :null => false
  end

  add_index "maestro_project_content", ["nid"], :name => "nid"

  create_table "maestro_projects", :force => true do |t|
    t.string  "project_num",       :limit => 12, :default => "", :null => false
    t.integer "originator_uid",                  :default => 0,  :null => false
    t.string  "description",                     :default => "", :null => false
    t.integer "status",            :limit => 1,  :default => 0,  :null => false
    t.integer "prev_status",       :limit => 1,  :default => 0,  :null => false
    t.string  "related_processes",               :default => "", :null => false
  end

  add_index "maestro_projects", ["originator_uid"], :name => "originator_uid"
  add_index "maestro_projects", ["project_num"], :name => "project_num"
  add_index "maestro_projects", ["status"], :name => "status"

  create_table "maestro_queue", :force => true do |t|
    t.integer "process_id",                        :default => 0,  :null => false
    t.integer "template_data_id",                  :default => 0
    t.string  "task_class_name",    :limit => 100, :default => "", :null => false
    t.integer "engine_version",                    :default => 0,  :null => false
    t.integer "is_interactive",                    :default => 0,  :null => false
    t.integer "show_in_detail",                    :default => 0,  :null => false
    t.string  "handler",                           :default => "", :null => false
    t.text    "task_data"
    t.text    "temp_data"
    t.integer "status"
    t.integer "archived"
    t.integer "run_once",           :limit => 1,   :default => 0,  :null => false
    t.integer "uid"
    t.integer "prepopulate"
    t.integer "created_date"
    t.integer "started_date"
    t.integer "completed_date"
    t.integer "next_reminder_time"
    t.integer "num_reminders_sent", :limit => 1,   :default => 0,  :null => false
  end

  add_index "maestro_queue", ["archived"], :name => "archived"
  add_index "maestro_queue", ["process_id"], :name => "process_id"
  add_index "maestro_queue", ["status"], :name => "status"
  add_index "maestro_queue", ["template_data_id"], :name => "template_data_id"

  create_table "maestro_queue_from", :force => true do |t|
    t.integer "queue_id"
    t.integer "from_queue_id"
  end

  create_table "maestro_template", :force => true do |t|
    t.string  "template_name", :limit => 100, :default => "",  :null => false
    t.integer "canvas_height",                :default => 500, :null => false
    t.integer "app_group",                    :default => 0,   :null => false
  end

  create_table "maestro_template_assignment", :force => true do |t|
    t.integer "template_data_id",              :default => 0, :null => false
    t.integer "assign_type",      :limit => 1, :default => 0, :null => false
    t.integer "assign_by",        :limit => 1, :default => 0, :null => false
    t.integer "assign_id",                     :default => 0, :null => false
  end

  add_index "maestro_template_assignment", ["assign_id"], :name => "assign_id"
  add_index "maestro_template_assignment", ["template_data_id"], :name => "template_data_id"

  create_table "maestro_template_data", :force => true do |t|
    t.integer "template_id",                                 :default => 0,  :null => false
    t.string  "task_class_name",              :limit => 100, :default => "", :null => false
    t.integer "is_interactive",                              :default => 0,  :null => false
    t.text    "task_data"
    t.string  "handler",                                     :default => "", :null => false
    t.integer "first_task",                   :limit => 1,   :default => 0,  :null => false
    t.string  "taskname",                     :limit => 150
    t.string  "argument_variable"
    t.integer "regenerate",                   :limit => 1,   :default => 0,  :null => false
    t.integer "regen_all_live_tasks",         :limit => 1,   :default => 0
    t.integer "show_in_detail",               :limit => 1,   :default => 0
    t.integer "is_dynamic_taskname",          :limit => 1,   :default => 0,  :null => false
    t.integer "dynamic_taskname_variable_id",                :default => 0,  :null => false
    t.integer "reminder_interval",            :limit => 1,   :default => 0,  :null => false
    t.integer "escalation_interval",          :limit => 1,   :default => 0,  :null => false
    t.integer "last_updated",                                :default => 0,  :null => false
    t.string  "pre_notify_subject",           :limit => 127
    t.string  "post_notify_subject",          :limit => 127
    t.string  "reminder_subject",             :limit => 127
    t.string  "escalation_subject",           :limit => 127
    t.string  "pre_notify_message",                          :default => "", :null => false
    t.string  "post_notify_message",                         :default => "", :null => false
    t.string  "reminder_message",                            :default => "", :null => false
    t.string  "escalation_message",                          :default => "", :null => false
    t.integer "num_reminders",                :limit => 1,   :default => 0,  :null => false
    t.integer "offset_left",                  :limit => 2,   :default => 0,  :null => false
    t.integer "offset_top",                   :limit => 2,   :default => 0,  :null => false
    t.integer "surpress_first_notification",  :limit => 1,   :default => 0,  :null => false
  end

  add_index "maestro_template_data", ["template_id"], :name => "template_id"

  create_table "maestro_template_data_next_step", :force => true do |t|
    t.integer "template_data_from",     :default => 0, :null => false
    t.integer "template_data_to",       :default => 0
    t.integer "template_data_to_false"
  end

  create_table "maestro_template_notification", :force => true do |t|
    t.integer "template_data_id",              :default => 0, :null => false
    t.integer "notify_type",      :limit => 1, :default => 0, :null => false
    t.integer "notify_by",        :limit => 1, :default => 0, :null => false
    t.integer "notify_when",      :limit => 1, :default => 0, :null => false
    t.integer "notify_id",                     :default => 0, :null => false
  end

  add_index "maestro_template_notification", ["notify_id"], :name => "notify_id"
  add_index "maestro_template_notification", ["template_data_id"], :name => "template_data_id"

  create_table "maestro_template_variables", :force => true do |t|
    t.integer "template_id",                   :default => 0,  :null => false
    t.string  "variable_name",  :limit => 100, :default => "", :null => false
    t.string  "variable_value",                :default => "", :null => false
  end

  add_index "maestro_template_variables", ["template_id"], :name => "template_id"

  create_table "menu_custom", :primary_key => "menu_name", :force => true do |t|
    t.string "title",       :default => "", :null => false
    t.text   "description"
  end

  create_table "menu_links", :primary_key => "mlid", :force => true do |t|
    t.string  "menu_name",    :limit => 32, :default => "",       :null => false
    t.integer "plid",                       :default => 0,        :null => false
    t.string  "link_path",                  :default => "",       :null => false
    t.string  "router_path",                :default => "",       :null => false
    t.string  "link_title",                 :default => "",       :null => false
    t.binary  "options"
    t.string  "module",                     :default => "system", :null => false
    t.integer "hidden",       :limit => 2,  :default => 0,        :null => false
    t.integer "external",     :limit => 2,  :default => 0,        :null => false
    t.integer "has_children", :limit => 2,  :default => 0,        :null => false
    t.integer "expanded",     :limit => 2,  :default => 0,        :null => false
    t.integer "weight",                     :default => 0,        :null => false
    t.integer "depth",        :limit => 2,  :default => 0,        :null => false
    t.integer "customized",   :limit => 2,  :default => 0,        :null => false
    t.integer "p1",                         :default => 0,        :null => false
    t.integer "p2",                         :default => 0,        :null => false
    t.integer "p3",                         :default => 0,        :null => false
    t.integer "p4",                         :default => 0,        :null => false
    t.integer "p5",                         :default => 0,        :null => false
    t.integer "p6",                         :default => 0,        :null => false
    t.integer "p7",                         :default => 0,        :null => false
    t.integer "p8",                         :default => 0,        :null => false
    t.integer "p9",                         :default => 0,        :null => false
    t.integer "updated",      :limit => 2,  :default => 0,        :null => false
  end

  add_index "menu_links", ["link_path", "menu_name"], :name => "path_menu", :length => {"link_path"=>128, "menu_name"=>nil}
  add_index "menu_links", ["menu_name", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"], :name => "menu_parents"
  add_index "menu_links", ["menu_name", "plid", "expanded", "has_children"], :name => "menu_plid_expand_child"
  add_index "menu_links", ["router_path"], :name => "router_path", :length => {"router_path"=>128}

  create_table "menu_per_role", :primary_key => "mlid", :force => true do |t|
    t.text "rids",  :null => false
    t.text "hrids", :null => false
  end

  create_table "menu_router", :primary_key => "path", :force => true do |t|
    t.binary  "load_functions",                                        :null => false
    t.binary  "to_arg_functions",                                      :null => false
    t.string  "access_callback",                       :default => "", :null => false
    t.binary  "access_arguments"
    t.string  "page_callback",                         :default => "", :null => false
    t.binary  "page_arguments"
    t.string  "delivery_callback",                     :default => "", :null => false
    t.integer "fit",                                   :default => 0,  :null => false
    t.integer "number_parts",      :limit => 2,        :default => 0,  :null => false
    t.integer "context",                               :default => 0,  :null => false
    t.string  "tab_parent",                            :default => "", :null => false
    t.string  "tab_root",                              :default => "", :null => false
    t.string  "title",                                 :default => "", :null => false
    t.string  "title_callback",                        :default => "", :null => false
    t.string  "title_arguments",                       :default => "", :null => false
    t.string  "theme_callback",                        :default => "", :null => false
    t.string  "theme_arguments",                       :default => "", :null => false
    t.integer "type",                                  :default => 0,  :null => false
    t.text    "description",                                           :null => false
    t.string  "position",                              :default => "", :null => false
    t.integer "weight",                                :default => 0,  :null => false
    t.text    "include_file",      :limit => 16777215
  end

  add_index "menu_router", ["fit"], :name => "fit"
  add_index "menu_router", ["tab_parent", "weight", "title"], :name => "tab_parent", :length => {"tab_parent"=>64, "weight"=>nil, "title"=>nil}
  add_index "menu_router", ["tab_root", "weight", "title"], :name => "tab_root_weight_title", :length => {"tab_root"=>64, "weight"=>nil, "title"=>nil}

  create_table "my_posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "news_rec", :force => true do |t|
    t.integer  "news_id",                     :null => false
    t.integer  "recommend_type", :limit => 1, :null => false
    t.integer  "weight",         :limit => 2
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "image_fid"
  end

  add_index "news_rec", ["news_id"], :name => "news_id"

  create_table "node", :primary_key => "nid", :force => true do |t|
    t.integer "vid",                     :default => 0,  :null => false
    t.string  "type",      :limit => 32, :default => "", :null => false
    t.string  "language",  :limit => 12, :default => "", :null => false
    t.string  "title",                   :default => "", :null => false
    t.integer "uid",                     :default => 0,  :null => false
    t.integer "status",                  :default => 1,  :null => false
    t.integer "created",                 :default => 0,  :null => false
    t.integer "changed",                 :default => 0,  :null => false
    t.integer "comment",                 :default => 0,  :null => false
    t.integer "promote",                 :default => 0,  :null => false
    t.integer "sticky",                  :default => 0,  :null => false
    t.integer "tnid",                    :default => 0,  :null => false
    t.integer "translate",               :default => 0,  :null => false
  end

  add_index "node", ["changed"], :name => "node_changed"
  add_index "node", ["created"], :name => "node_created"
  add_index "node", ["promote", "status", "sticky", "created"], :name => "node_frontpage"
  add_index "node", ["status", "type", "nid"], :name => "node_status_type"
  add_index "node", ["title", "type"], :name => "node_title_type", :length => {"title"=>nil, "type"=>4}
  add_index "node", ["tnid"], :name => "tnid"
  add_index "node", ["translate"], :name => "translate"
  add_index "node", ["type"], :name => "node_type", :length => {"type"=>4}
  add_index "node", ["uid"], :name => "uid"
  add_index "node", ["vid"], :name => "vid", :unique => true

  create_table "node_access", :id => false, :force => true do |t|
    t.integer "nid",                       :default => 0,  :null => false
    t.integer "gid",                       :default => 0,  :null => false
    t.string  "realm",                     :default => "", :null => false
    t.integer "grant_view",   :limit => 1, :default => 0,  :null => false
    t.integer "grant_update", :limit => 1, :default => 0,  :null => false
    t.integer "grant_delete", :limit => 1, :default => 0,  :null => false
  end

  create_table "node_revision", :primary_key => "vid", :force => true do |t|
    t.integer "nid",                             :default => 0,  :null => false
    t.integer "uid",                             :default => 0,  :null => false
    t.string  "title",                           :default => "", :null => false
    t.text    "log",       :limit => 2147483647,                 :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
    t.integer "status",                          :default => 1,  :null => false
    t.integer "comment",                         :default => 0,  :null => false
    t.integer "promote",                         :default => 0,  :null => false
    t.integer "sticky",                          :default => 0,  :null => false
  end

  add_index "node_revision", ["nid"], :name => "nid"
  add_index "node_revision", ["uid"], :name => "uid"

  create_table "node_type", :primary_key => "type", :force => true do |t|
    t.string  "name",                            :default => "", :null => false
    t.string  "base",                                            :null => false
    t.string  "module",                                          :null => false
    t.text    "description", :limit => 16777215,                 :null => false
    t.text    "help",        :limit => 16777215,                 :null => false
    t.integer "has_title",   :limit => 1,                        :null => false
    t.string  "title_label",                     :default => "", :null => false
    t.integer "custom",      :limit => 1,        :default => 0,  :null => false
    t.integer "modified",    :limit => 1,        :default => 0,  :null => false
    t.integer "locked",      :limit => 1,        :default => 0,  :null => false
    t.integer "disabled",    :limit => 1,        :default => 0,  :null => false
    t.string  "orig_type",                       :default => "", :null => false
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

  create_table "performance_detail", :primary_key => "pid", :force => true do |t|
    t.integer "timestamp",                         :default => 0, :null => false
    t.integer "bytes",                             :default => 0, :null => false
    t.integer "ms",                                :default => 0, :null => false
    t.integer "query_count",                       :default => 0, :null => false
    t.integer "query_timer",                       :default => 0, :null => false
    t.integer "anon",                              :default => 1
    t.string  "path"
    t.binary  "data",        :limit => 2147483647
  end

  add_index "performance_detail", ["timestamp"], :name => "timestamp"

  create_table "performance_summary", :primary_key => "path", :force => true do |t|
    t.integer "last_access",     :default => 0, :null => false
    t.integer "bytes_max",       :default => 0, :null => false
    t.integer "bytes_avg",       :default => 0, :null => false
    t.integer "ms_max",          :default => 0, :null => false
    t.integer "ms_avg",          :default => 0, :null => false
    t.integer "query_count_max", :default => 0, :null => false
    t.integer "query_count_avg", :default => 0, :null => false
    t.integer "query_timer_max", :default => 0, :null => false
    t.integer "query_timer_avg", :default => 0, :null => false
    t.integer "num_accesses",    :default => 0, :null => false
  end

  add_index "performance_summary", ["last_access"], :name => "last_access"

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
    t.integer  "account_id",                                     :null => false
    t.string   "content"
    t.integer  "privilege",                                      :null => false
    t.integer  "status",             :limit => 1,                :null => false
    t.integer  "comment_count",                   :default => 0, :null => false
    t.integer  "recommend_count",                 :default => 0, :null => false
    t.integer  "like_count",                      :default => 0, :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "group_id"
    t.integer  "original_id"
    t.integer  "parent_id"
    t.integer  "post_type",          :limit => 1,                :null => false
    t.text     "main_body"
    t.integer  "original_author_id"
  end

  add_index "posts", ["account_id"], :name => "index_posts_on_account_id"
  add_index "posts", ["group_id"], :name => "index_posts_on_group_id"
  add_index "posts", ["original_author_id"], :name => "index_posts_on_original_author_id"
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

  create_table "queue", :primary_key => "item_id", :force => true do |t|
    t.string  "name",                          :default => "", :null => false
    t.binary  "data",    :limit => 2147483647
    t.integer "expire",                        :default => 0,  :null => false
    t.integer "created",                       :default => 0,  :null => false
  end

  add_index "queue", ["expire"], :name => "expire"
  add_index "queue", ["name", "created"], :name => "name_created"

  create_table "rdf_mapping", :id => false, :force => true do |t|
    t.string "type",    :limit => 128,        :null => false
    t.string "bundle",  :limit => 128,        :null => false
    t.binary "mapping", :limit => 2147483647
  end

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

  create_table "region_ip_sections", :force => true do |t|
    t.integer "region_id", :limit => 2, :null => false
    t.integer "start_ip",               :null => false
    t.integer "end_ip",                 :null => false
  end

  add_index "region_ip_sections", ["region_id"], :name => "region_id"
  add_index "region_ip_sections", ["start_ip", "end_ip", "region_id"], :name => "IDX_regions_ip_sections_start_ip_end_ip_region_id"

  create_table "region_sales", :force => true do |t|
    t.date     "date",                                                     :null => false
    t.integer  "region_id",    :limit => 2
    t.integer  "game_id",                                                  :null => false
    t.integer  "online_units",                                             :null => false
    t.decimal  "online_sum",                :precision => 10, :scale => 2, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "region_sales", ["date"], :name => "IDX_region_sales_date"
  add_index "region_sales", ["game_id"], :name => "game_id"
  add_index "region_sales", ["region_id"], :name => "region_id"

  create_table "regions", :force => true do |t|
    t.string "name",     :limit => 32,                  :null => false
    t.string "loc_key",  :limit => 128,                 :null => false
    t.string "postcode", :limit => 6,   :default => "", :null => false
  end

  add_index "regions", ["loc_key"], :name => "UQ_regions_loc_key", :unique => true
  add_index "regions", ["name"], :name => "UQ_regions_name", :unique => true

  create_table "registry", :id => false, :force => true do |t|
    t.string  "name",                  :default => "", :null => false
    t.string  "type",     :limit => 9, :default => "", :null => false
    t.string  "filename",                              :null => false
    t.string  "module",                :default => "", :null => false
    t.integer "weight",                :default => 0,  :null => false
  end

  add_index "registry", ["type", "weight", "module"], :name => "hook"

  create_table "registry_file", :primary_key => "filename", :force => true do |t|
    t.string "hash", :limit => 64, :null => false
  end

  create_table "role", :primary_key => "rid", :force => true do |t|
    t.string  "name",   :limit => 64, :default => "", :null => false
    t.integer "weight",               :default => 0,  :null => false
  end

  add_index "role", ["name", "weight"], :name => "name_weight"
  add_index "role", ["name"], :name => "name", :unique => true

  create_table "role_permission", :id => false, :force => true do |t|
    t.integer "rid",                                       :null => false
    t.string  "permission", :limit => 128, :default => "", :null => false
    t.string  "module",                    :default => "", :null => false
  end

  add_index "role_permission", ["permission"], :name => "permission"

  create_table "rules_config", :force => true do |t|
    t.string  "name",           :limit => 64,                                  :null => false
    t.string  "label",                                :default => "unlabeled", :null => false
    t.string  "plugin",         :limit => 127,                                 :null => false
    t.integer "active",                               :default => 1,           :null => false
    t.integer "weight",         :limit => 1,          :default => 0,           :null => false
    t.integer "status",         :limit => 1,          :default => 1,           :null => false
    t.integer "dirty",          :limit => 1,          :default => 0,           :null => false
    t.string  "module"
    t.binary  "data",           :limit => 2147483647
    t.integer "access_exposed", :limit => 1,          :default => 0,           :null => false
  end

  add_index "rules_config", ["name"], :name => "name", :unique => true
  add_index "rules_config", ["plugin"], :name => "plugin"

  create_table "rules_dependencies", :id => false, :force => true do |t|
    t.integer "id",     :null => false
    t.string  "module", :null => false
  end

  add_index "rules_dependencies", ["module"], :name => "module"

  create_table "rules_tags", :id => false, :force => true do |t|
    t.integer "id",  :null => false
    t.string  "tag", :null => false
  end

  create_table "rules_trigger", :id => false, :force => true do |t|
    t.integer "id",                                   :null => false
    t.string  "event", :limit => 127, :default => "", :null => false
  end

  create_table "search_dataset", :id => false, :force => true do |t|
    t.integer "sid",                           :default => 0, :null => false
    t.string  "type",    :limit => 16,                        :null => false
    t.text    "data",    :limit => 2147483647,                :null => false
    t.integer "reindex",                       :default => 0, :null => false
  end

  create_table "search_dummies", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "search_index", :id => false, :force => true do |t|
    t.string  "word",  :limit => 50, :default => "", :null => false
    t.integer "sid",                 :default => 0,  :null => false
    t.string  "type",  :limit => 16,                 :null => false
    t.float   "score"
  end

  add_index "search_index", ["sid", "type"], :name => "sid_type"

  create_table "search_node_links", :id => false, :force => true do |t|
    t.integer "sid",                           :default => 0,  :null => false
    t.string  "type",    :limit => 16,         :default => "", :null => false
    t.integer "nid",                           :default => 0,  :null => false
    t.text    "caption", :limit => 2147483647
  end

  add_index "search_node_links", ["nid"], :name => "nid"

  create_table "search_total", :primary_key => "word", :force => true do |t|
    t.float "count"
  end

  create_table "semaphore", :primary_key => "name", :force => true do |t|
    t.string "value",  :default => "", :null => false
    t.float  "expire",                 :null => false
  end

  add_index "semaphore", ["expire"], :name => "expire"
  add_index "semaphore", ["value"], :name => "value"

  create_table "sequences", :primary_key => "value", :force => true do |t|
  end

  create_table "serial_types", :force => true do |t|
    t.string  "type_name", :limit => 64, :null => false
    t.string  "type_desc",               :null => false
    t.integer "type_cat",  :limit => 2,  :null => false
  end

  add_index "serial_types", ["type_name"], :name => "idx_serial_types_type_name"
  add_index "serial_types", ["type_name"], :name => "uni_serial_types_type_name", :unique => true

  create_table "sessions", :id => false, :force => true do |t|
    t.integer "uid",                                             :null => false
    t.string  "sid",       :limit => 128,                        :null => false
    t.string  "ssid",      :limit => 128,        :default => "", :null => false
    t.string  "hostname",  :limit => 128,        :default => "", :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
    t.integer "cache",                           :default => 0,  :null => false
    t.binary  "session",   :limit => 2147483647
  end

  add_index "sessions", ["ssid"], :name => "ssid"
  add_index "sessions", ["timestamp"], :name => "timestamp"
  add_index "sessions", ["uid"], :name => "uid"

  create_table "shortcut_set", :primary_key => "set_name", :force => true do |t|
    t.string "title", :default => "", :null => false
  end

  create_table "shortcut_set_users", :primary_key => "uid", :force => true do |t|
    t.string "set_name", :limit => 32, :default => "", :null => false
  end

  add_index "shortcut_set_users", ["set_name"], :name => "set_name"

  create_table "simpletest", :primary_key => "message_id", :force => true do |t|
    t.integer "test_id",                    :default => 0,  :null => false
    t.string  "test_class",                 :default => "", :null => false
    t.string  "status",        :limit => 9, :default => "", :null => false
    t.text    "message",                                    :null => false
    t.string  "message_group",              :default => "", :null => false
    t.string  "function",                   :default => "", :null => false
    t.integer "line",                       :default => 0,  :null => false
    t.string  "file",                       :default => "", :null => false
  end

  add_index "simpletest", ["test_class", "message_id"], :name => "reporter"

  create_table "simpletest_test_id", :primary_key => "test_id", :force => true do |t|
    t.string "last_prefix", :limit => 60, :default => ""
  end

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

  create_table "system", :primary_key => "filename", :force => true do |t|
    t.string  "name",                         :default => "", :null => false
    t.string  "type",           :limit => 12, :default => "", :null => false
    t.string  "owner",                        :default => "", :null => false
    t.integer "status",                       :default => 0,  :null => false
    t.integer "bootstrap",                    :default => 0,  :null => false
    t.integer "schema_version", :limit => 2,  :default => -1, :null => false
    t.integer "weight",                       :default => 0,  :null => false
    t.binary  "info"
  end

  add_index "system", ["status", "bootstrap", "type", "weight", "name"], :name => "system_list"
  add_index "system", ["type", "name"], :name => "type_name"

  create_table "tags", :force => true do |t|
    t.string  "name",                  :null => false
    t.integer "category", :limit => 1, :null => false
  end

  create_table "taxonomy_index", :id => false, :force => true do |t|
    t.integer "nid",                  :default => 0, :null => false
    t.integer "tid",                  :default => 0, :null => false
    t.integer "sticky",  :limit => 1, :default => 0
    t.integer "created",              :default => 0, :null => false
  end

  add_index "taxonomy_index", ["nid"], :name => "nid"
  add_index "taxonomy_index", ["tid", "sticky", "created"], :name => "term_node"

  create_table "taxonomy_term_data", :primary_key => "tid", :force => true do |t|
    t.integer "vid",                               :default => 0,  :null => false
    t.string  "name",                              :default => "", :null => false
    t.text    "description", :limit => 2147483647
    t.string  "format"
    t.integer "weight",                            :default => 0,  :null => false
  end

  add_index "taxonomy_term_data", ["name"], :name => "name"
  add_index "taxonomy_term_data", ["vid", "name"], :name => "vid_name"
  add_index "taxonomy_term_data", ["vid", "weight", "name"], :name => "taxonomy_tree"

  create_table "taxonomy_term_hierarchy", :id => false, :force => true do |t|
    t.integer "tid",    :default => 0, :null => false
    t.integer "parent", :default => 0, :null => false
  end

  add_index "taxonomy_term_hierarchy", ["parent"], :name => "parent"

  create_table "taxonomy_vocabulary", :primary_key => "vid", :force => true do |t|
    t.string  "name",                               :default => "", :null => false
    t.string  "machine_name",                       :default => "", :null => false
    t.text    "description",  :limit => 2147483647
    t.integer "hierarchy",    :limit => 1,          :default => 0,  :null => false
    t.string  "module",                             :default => "", :null => false
    t.integer "weight",                             :default => 0,  :null => false
  end

  add_index "taxonomy_vocabulary", ["machine_name"], :name => "machine_name", :unique => true
  add_index "taxonomy_vocabulary", ["weight", "name"], :name => "list"

  create_table "tipoff_reasons", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "tipoffs", :force => true do |t|
    t.integer  "account_id",                     :null => false
    t.integer  "target_account_id",              :null => false
    t.integer  "detail_id",                      :null => false
    t.string   "detail_type",                    :null => false
    t.integer  "reason_id",                      :null => false
    t.integer  "status",            :limit => 1, :null => false
    t.integer  "censor_id"
    t.integer  "handling_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "tipoffs", ["account_id"], :name => "index_tipoffs_on_account_id"
  add_index "tipoffs", ["censor_id"], :name => "index_tipoffs_on_censor_id"
  add_index "tipoffs", ["detail_type", "detail_id"], :name => "idx_tipoffs_detail_type_id"
  add_index "tipoffs", ["reason_id"], :name => "index_tipoffs_on_reason_id"

  create_table "trigger_assignments", :id => false, :force => true do |t|
    t.string  "hook",   :limit => 32, :default => "", :null => false
    t.string  "aid",                  :default => "", :null => false
    t.integer "weight",               :default => 0,  :null => false
  end

  create_table "uc_cart_link_clicks", :primary_key => "cart_link_id", :force => true do |t|
    t.integer "clicks",     :default => 0, :null => false
    t.integer "last_click", :default => 0, :null => false
  end

  create_table "uc_cart_products", :primary_key => "cart_item_id", :force => true do |t|
    t.string  "cart_id", :default => "0", :null => false
    t.integer "nid",     :default => 0,   :null => false
    t.integer "qty",     :default => 0,   :null => false
    t.integer "changed", :default => 0,   :null => false
    t.text    "data"
  end

  add_index "uc_cart_products", ["cart_id"], :name => "cart_id"

  create_table "uc_countries", :primary_key => "country_id", :force => true do |t|
    t.string  "country_name",                    :default => "", :null => false
    t.string  "country_iso_code_2", :limit => 2, :default => "", :null => false
    t.string  "country_iso_code_3", :limit => 3, :default => "", :null => false
    t.integer "version",            :limit => 2, :default => 0,  :null => false
  end

  add_index "uc_countries", ["country_name"], :name => "country_name"

  create_table "uc_coupon_custom_users", :primary_key => "ccuid", :force => true do |t|
    t.integer "uid",                                    :null => false
    t.integer "cid",                                    :null => false
    t.string  "code",    :limit => 100, :default => "", :null => false
    t.integer "created",                :default => 0,  :null => false
  end

  add_index "uc_coupon_custom_users", ["cid"], :name => "cid"
  add_index "uc_coupon_custom_users", ["code"], :name => "code", :length => {"code"=>10}

  create_table "uc_coupon_event_coupons", :primary_key => "ecid", :force => true do |t|
    t.integer "cid",                                       :null => false
    t.string  "event_name", :limit => 64,  :default => "", :null => false
    t.string  "code",       :limit => 100, :default => "", :null => false
    t.integer "status",     :limit => 2,   :default => 0,  :null => false
    t.integer "created",                   :default => 0,  :null => false
    t.integer "updated",                   :default => 0,  :null => false
  end

  add_index "uc_coupon_event_coupons", ["cid"], :name => "cid"
  add_index "uc_coupon_event_coupons", ["ecid"], :name => "ecid"
  add_index "uc_coupon_event_coupons", ["event_name"], :name => "event_name"

  create_table "uc_coupon_purchase", :primary_key => "pfid", :force => true do |t|
    t.integer "nid",                    :default => 0,  :null => false
    t.string  "model",    :limit => 30, :default => "", :null => false
    t.integer "base_cid",               :default => 0,  :null => false
  end

  add_index "uc_coupon_purchase", ["model"], :name => "model"
  add_index "uc_coupon_purchase", ["nid"], :name => "nid"

  create_table "uc_coupon_purchase_users", :primary_key => "cpuid", :force => true do |t|
    t.integer "uid", :null => false
    t.integer "cid", :null => false
  end

  create_table "uc_coupons", :primary_key => "cid", :force => true do |t|
    t.string  "name",                                                        :default => "",      :null => false
    t.string  "code",          :limit => 100,                                :default => "",      :null => false
    t.decimal "value",                        :precision => 10, :scale => 2, :default => 0.0,     :null => false
    t.string  "type",          :limit => 12,                                 :default => "price", :null => false
    t.integer "status",        :limit => 1,                                  :default => 1,       :null => false
    t.integer "valid_from"
    t.integer "valid_until"
    t.integer "max_uses",      :limit => 2,                                  :default => 0,       :null => false
    t.decimal "minimum_order",                :precision => 10, :scale => 2, :default => 0.0,     :null => false
    t.text    "data"
    t.integer "bulk",          :limit => 1,                                  :default => 0,       :null => false
    t.string  "bulk_seed",     :limit => 32,                                 :default => "",      :null => false
    t.integer "created",                                                     :default => 0,       :null => false
  end

  create_table "uc_coupons_orders", :primary_key => "cuid", :force => true do |t|
    t.integer "cid",                                                 :default => 0,   :null => false
    t.integer "oid",                                                 :default => 0,   :null => false
    t.decimal "value",                :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string  "code",  :limit => 100,                                :default => "",  :null => false
  end

  create_table "uc_discounts", :primary_key => "discount_id", :force => true do |t|
    t.string  "name",                                                   :default => "",  :null => false
    t.string  "short_description",                       :limit => 100, :default => "",  :null => false
    t.string  "description",                             :limit => 100, :default => "",  :null => false
    t.integer "qualifying_type",                                        :default => 0,   :null => false
    t.float   "qualifying_amount",                                      :default => 0.0, :null => false
    t.integer "has_qualifying_amount_max",               :limit => 1,   :default => 0,   :null => false
    t.float   "qualifying_amount_max",                                  :default => 0.0, :null => false
    t.integer "discount_type",                                          :default => 0,   :null => false
    t.float   "discount_amount",                                        :default => 0.0, :null => false
    t.integer "requires_code",                           :limit => 1,   :default => 1,   :null => false
    t.integer "filter_type",                                            :default => 1,   :null => false
    t.integer "has_role_filter",                         :limit => 1,   :default => 0,   :null => false
    t.integer "use_only_discounted_products_to_qualify", :limit => 1,   :default => 0,   :null => false
    t.integer "requires_single_product_to_qualify",      :limit => 1,   :default => 1,   :null => false
    t.integer "required_product_type",                   :limit => 1,   :default => 0,   :null => false
    t.integer "max_times_applied",                                      :default => 1,   :null => false
    t.integer "limit_max_times_applied",                 :limit => 1,   :default => 0,   :null => false
    t.integer "can_be_combined_with_other_discounts",    :limit => 1,   :default => 0,   :null => false
    t.integer "add_to_cart",                             :limit => 1,   :default => 0
    t.integer "max_uses",                                               :default => 0,   :null => false
    t.integer "max_uses_per_user",                                      :default => 1,   :null => false
    t.integer "max_uses_per_code",                                      :default => 0,   :null => false
    t.integer "has_activation",                          :limit => 1,   :default => 0,   :null => false
    t.integer "activates_on",                                           :default => 0,   :null => false
    t.integer "has_expiration",                          :limit => 1,   :default => 0,   :null => false
    t.integer "expiration",                                             :default => 0,   :null => false
    t.integer "is_active",                               :limit => 1,   :default => 0
    t.integer "weight",                                  :limit => 1,   :default => 0,   :null => false
    t.integer "insert_timestamp",                                       :default => 0,   :null => false
  end

  create_table "uc_discounts_authors", :primary_key => "discount_author_id", :force => true do |t|
    t.integer "discount_id",                             :null => false
    t.integer "author_id",                               :null => false
    t.integer "grouping",    :limit => 1, :default => 1, :null => false
  end

  add_index "uc_discounts_authors", ["discount_id", "grouping"], :name => "discount_id_grouping"

  create_table "uc_discounts_classes", :primary_key => "discount_class_id", :force => true do |t|
    t.integer "discount_id",                              :null => false
    t.string  "class",       :limit => 32,                :null => false
    t.integer "grouping",    :limit => 1,  :default => 1, :null => false
  end

  add_index "uc_discounts_classes", ["discount_id", "grouping"], :name => "discount_id_grouping"

  create_table "uc_discounts_codes", :primary_key => "discount_code_id", :force => true do |t|
    t.integer "discount_id",                :default => 0,  :null => false
    t.string  "code",        :limit => 100, :default => "", :null => false
  end

  create_table "uc_discounts_order_codes", :id => false, :force => true do |t|
    t.integer "order_id", :null => false
    t.text    "codes",    :null => false
  end

  create_table "uc_discounts_products", :primary_key => "discount_product_id", :force => true do |t|
    t.integer "discount_id",                             :null => false
    t.integer "product_id",                              :null => false
    t.integer "grouping",    :limit => 1, :default => 1, :null => false
  end

  add_index "uc_discounts_products", ["discount_id", "grouping"], :name => "discount_id_grouping"

  create_table "uc_discounts_roles", :primary_key => "discount_role_id", :force => true do |t|
    t.integer "discount_id", :null => false
    t.integer "role_id",     :null => false
  end

  create_table "uc_discounts_skus", :primary_key => "discount_sku_id", :force => true do |t|
    t.integer "discount_id",                             :null => false
    t.string  "sku",                                     :null => false
    t.integer "grouping",    :limit => 1, :default => 1, :null => false
  end

  add_index "uc_discounts_skus", ["discount_id", "grouping"], :name => "discount_id_grouping"

  create_table "uc_discounts_terms", :primary_key => "discount_term_id", :force => true do |t|
    t.integer "discount_id",                             :null => false
    t.integer "term_id",                                 :null => false
    t.integer "grouping",    :limit => 1, :default => 1, :null => false
  end

  add_index "uc_discounts_terms", ["discount_id", "grouping"], :name => "discount_id_grouping"

  create_table "uc_discounts_uses", :primary_key => "discount_use_id", :force => true do |t|
    t.integer "discount_id",                     :default => 0,   :null => false
    t.integer "user_id",                         :default => 0,   :null => false
    t.integer "order_id",                        :default => 0,   :null => false
    t.string  "code",             :limit => 100, :default => "",  :null => false
    t.integer "times_applied",                   :default => 1,   :null => false
    t.float   "amount",                          :default => 0.0, :null => false
    t.integer "insert_timestamp",                :default => 0,   :null => false
  end

  create_table "uc_order_admin_comments", :primary_key => "comment_id", :force => true do |t|
    t.integer "order_id", :default => 0, :null => false
    t.integer "uid",      :default => 0, :null => false
    t.text    "message"
    t.integer "created",  :default => 0, :null => false
  end

  add_index "uc_order_admin_comments", ["order_id"], :name => "order_id"

  create_table "uc_order_comments", :primary_key => "comment_id", :force => true do |t|
    t.integer "order_id",                   :default => 0,  :null => false
    t.integer "uid",                        :default => 0,  :null => false
    t.string  "order_status", :limit => 32, :default => "", :null => false
    t.integer "notified",     :limit => 1,  :default => 0,  :null => false
    t.text    "message"
    t.integer "created",                    :default => 0,  :null => false
  end

  add_index "uc_order_comments", ["order_id"], :name => "order_id"

  create_table "uc_order_ext_exceptions", :primary_key => "eid", :force => true do |t|
    t.integer "order_id",                                                 :null => false
    t.decimal "value",    :precision => 16, :scale => 5, :default => 0.0, :null => false
  end

  add_index "uc_order_ext_exceptions", ["eid"], :name => "eid"

  create_table "uc_order_exts", :primary_key => "spid", :force => true do |t|
    t.integer "order_id",                                                   :null => false
    t.integer "game_id",                                                    :null => false
    t.decimal "price",      :precision => 16, :scale => 5, :default => 0.0, :null => false
    t.decimal "real_price", :precision => 16, :scale => 5, :default => 0.0, :null => false
  end

  add_index "uc_order_exts", ["game_id"], :name => "game_id"
  add_index "uc_order_exts", ["order_id"], :name => "order_id"
  add_index "uc_order_exts", ["spid"], :name => "spid"

  create_table "uc_order_line_items", :primary_key => "line_item_id", :force => true do |t|
    t.integer "order_id",                                              :default => 0,   :null => false
    t.string  "type",     :limit => 32,                                :default => "",  :null => false
    t.string  "title",                                                 :default => "",  :null => false
    t.decimal "amount",                 :precision => 16, :scale => 5, :default => 0.0, :null => false
    t.integer "weight",   :limit => 2,                                 :default => 0,   :null => false
    t.text    "data"
  end

  add_index "uc_order_line_items", ["order_id"], :name => "order_id"

  create_table "uc_order_log", :primary_key => "order_log_id", :force => true do |t|
    t.integer "order_id", :default => 0, :null => false
    t.integer "uid",      :default => 0, :null => false
    t.text    "changes"
    t.integer "created",  :default => 0, :null => false
  end

  add_index "uc_order_log", ["order_id"], :name => "order_id"

  create_table "uc_order_products", :primary_key => "order_product_id", :force => true do |t|
    t.integer "order_id",                                    :default => 0,    :null => false
    t.integer "nid",                                         :default => 0,    :null => false
    t.string  "title",                                       :default => "",   :null => false
    t.string  "model",                                       :default => "",   :null => false
    t.integer "qty",                                         :default => 0,    :null => false
    t.decimal "cost",         :precision => 16, :scale => 5, :default => 0.0,  :null => false
    t.decimal "price",        :precision => 16, :scale => 5, :default => 0.0,  :null => false
    t.float   "weight",                                      :default => 0.0,  :null => false
    t.string  "weight_units",                                :default => "lb", :null => false
    t.text    "data"
  end

  add_index "uc_order_products", ["nid"], :name => "nid"
  add_index "uc_order_products", ["order_id"], :name => "order_id"
  add_index "uc_order_products", ["qty"], :name => "qty"

  create_table "uc_order_statuses", :primary_key => "order_status_id", :force => true do |t|
    t.string  "title",  :limit => 48, :default => "", :null => false
    t.string  "state",  :limit => 32, :default => "", :null => false
    t.integer "weight", :limit => 2,  :default => 0,  :null => false
    t.integer "locked", :limit => 1,  :default => 0,  :null => false
  end

  create_table "uc_orders", :primary_key => "order_id", :force => true do |t|
    t.integer "uid",                                                               :default => 0,   :null => false
    t.string  "order_status",         :limit => 32,                                :default => "",  :null => false
    t.decimal "order_total",                        :precision => 16, :scale => 5, :default => 0.0, :null => false
    t.integer "product_count",                                                     :default => 0,   :null => false
    t.string  "primary_email",        :limit => 96,                                :default => "",  :null => false
    t.string  "delivery_first_name",                                               :default => "",  :null => false
    t.string  "delivery_last_name",                                                :default => "",  :null => false
    t.string  "delivery_phone",                                                    :default => "",  :null => false
    t.string  "delivery_company",                                                  :default => "",  :null => false
    t.string  "delivery_street1",                                                  :default => "",  :null => false
    t.string  "delivery_street2",                                                  :default => "",  :null => false
    t.string  "delivery_city",                                                     :default => "",  :null => false
    t.integer "delivery_zone",        :limit => 3,                                 :default => 0,   :null => false
    t.string  "delivery_postal_code",                                              :default => "",  :null => false
    t.integer "delivery_country",     :limit => 3,                                 :default => 0,   :null => false
    t.string  "billing_first_name",                                                :default => "",  :null => false
    t.string  "billing_last_name",                                                 :default => "",  :null => false
    t.string  "billing_phone",                                                     :default => "",  :null => false
    t.string  "billing_company",                                                   :default => "",  :null => false
    t.string  "billing_street1",                                                   :default => "",  :null => false
    t.string  "billing_street2",                                                   :default => "",  :null => false
    t.string  "billing_city",                                                      :default => "",  :null => false
    t.integer "billing_zone",         :limit => 3,                                 :default => 0,   :null => false
    t.string  "billing_postal_code",                                               :default => "",  :null => false
    t.integer "billing_country",      :limit => 3,                                 :default => 0,   :null => false
    t.string  "payment_method",       :limit => 32,                                :default => "",  :null => false
    t.text    "data"
    t.integer "created",                                                           :default => 0,   :null => false
    t.integer "modified",                                                          :default => 0,   :null => false
    t.string  "host",                                                              :default => "",  :null => false
    t.string  "currency",             :limit => 3,                                 :default => "",  :null => false
  end

  add_index "uc_orders", ["order_status"], :name => "order_status"
  add_index "uc_orders", ["uid"], :name => "uid"

  create_table "uc_payment_receipts", :primary_key => "receipt_id", :force => true do |t|
    t.integer "order_id",                                              :default => 0,   :null => false
    t.string  "method",   :limit => 32,                                :default => "",  :null => false
    t.decimal "amount",                 :precision => 16, :scale => 5, :default => 0.0, :null => false
    t.integer "uid",                                                   :default => 0,   :null => false
    t.text    "data"
    t.text    "comment"
    t.integer "received",                                              :default => 0,   :null => false
  end

  add_index "uc_payment_receipts", ["order_id"], :name => "order_id"

  create_table "uc_product_classes", :primary_key => "pcid", :force => true do |t|
    t.string "name",        :default => "", :null => false
    t.text   "description"
  end

  create_table "uc_product_features", :primary_key => "pfid", :force => true do |t|
    t.integer "nid",                       :default => 0,  :null => false
    t.string  "fid",         :limit => 32, :default => "", :null => false
    t.text    "description"
  end

  add_index "uc_product_features", ["nid"], :name => "nid"

  create_table "uc_product_kits", :id => false, :force => true do |t|
    t.integer "vid",                       :default => 0,   :null => false
    t.integer "nid",                       :default => 0,   :null => false
    t.integer "product_id",                :default => 0,   :null => false
    t.integer "mutable",      :limit => 1, :default => 0,   :null => false
    t.integer "qty",          :limit => 2, :default => 0,   :null => false
    t.float   "discount",                  :default => 0.0, :null => false
    t.integer "ordering",     :limit => 2, :default => 0,   :null => false
    t.integer "synchronized", :limit => 1, :default => 0,   :null => false
  end

  create_table "uc_products", :primary_key => "vid", :force => true do |t|
    t.integer "nid",                                                         :default => 0,                                  :null => false
    t.string  "model",        :limit => 1023,                                                                                :null => false
    t.decimal "list_price",                   :precision => 16, :scale => 5, :default => 0.0,                                :null => false
    t.decimal "cost",                         :precision => 16, :scale => 5, :default => 0.0,                                :null => false
    t.decimal "sell_price",                   :precision => 16, :scale => 5, :default => 0.0,                                :null => false
    t.float   "weight",                                                      :default => 0.0,                                :null => false
    t.string  "weight_units",                                                :default => "lb",                               :null => false
    t.float   "length",                                                      :default => 0.0,                                :null => false
    t.float   "width",                                                       :default => 0.0,                                :null => false
    t.float   "height",                                                      :default => 0.0,                                :null => false
    t.string  "length_units",                                                :default => "in",                               :null => false
    t.integer "pkg_qty",      :limit => 2,                                   :default => 1,                                  :null => false
    t.integer "default_qty",  :limit => 2,                                   :default => 1,                                  :null => false
    t.string  "unique_hash",  :limit => 32,                                  :default => "d41d8cd98f00b204e9800998ecf8427e", :null => false
    t.integer "ordering",     :limit => 1,                                   :default => 0,                                  :null => false
    t.integer "shippable",    :limit => 1,                                   :default => 1,                                  :null => false
  end

  add_index "uc_products", ["nid"], :name => "nid"

  create_table "uc_zones", :primary_key => "zone_id", :force => true do |t|
    t.integer "zone_country_id",               :default => 0,  :null => false
    t.string  "zone_code",       :limit => 32, :default => "", :null => false
    t.string  "zone_name",                     :default => "", :null => false
  end

  add_index "uc_zones", ["zone_code"], :name => "zone_code"
  add_index "uc_zones", ["zone_country_id"], :name => "zone_country_id"

  create_table "url_alias", :primary_key => "pid", :force => true do |t|
    t.string "source",                 :default => "", :null => false
    t.string "alias",                  :default => "", :null => false
    t.string "language", :limit => 12, :default => "", :null => false
  end

  add_index "url_alias", ["alias", "language", "pid"], :name => "alias_language_pid"
  add_index "url_alias", ["source", "language", "pid"], :name => "source_language_pid"

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

  create_table "users", :primary_key => "uid", :force => true do |t|
    t.string  "name",             :limit => 60,         :default => "", :null => false
    t.string  "pass",             :limit => 128,        :default => "", :null => false
    t.string  "mail",             :limit => 254,        :default => ""
    t.string  "theme",                                  :default => "", :null => false
    t.string  "signature",                              :default => "", :null => false
    t.string  "signature_format"
    t.integer "created",                                :default => 0,  :null => false
    t.integer "access",                                 :default => 0,  :null => false
    t.integer "login",                                  :default => 0,  :null => false
    t.integer "status",           :limit => 1,          :default => 0,  :null => false
    t.string  "timezone",         :limit => 32
    t.string  "language",         :limit => 12,         :default => "", :null => false
    t.integer "picture",                                :default => 0,  :null => false
    t.string  "init",             :limit => 254,        :default => ""
    t.binary  "data",             :limit => 2147483647
  end

  add_index "users", ["access"], :name => "access"
  add_index "users", ["created"], :name => "created"
  add_index "users", ["mail"], :name => "mail"
  add_index "users", ["name"], :name => "name", :unique => true

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

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "uid", :default => 0, :null => false
    t.integer "rid", :default => 0, :null => false
  end

  add_index "users_roles", ["rid"], :name => "rid"

  create_table "variable", :primary_key => "name", :force => true do |t|
    t.binary "value", :limit => 2147483647, :null => false
  end

  create_table "video_output", :id => false, :force => true do |t|
    t.integer "vid",                         :null => false
    t.integer "original_fid",                :null => false
    t.integer "output_fid",   :default => 0, :null => false
    t.integer "job_id"
  end

  create_table "video_preset", :primary_key => "pid", :force => true do |t|
    t.string "name",        :limit => 64,         :default => "", :null => false
    t.text   "description", :limit => 16777215
    t.binary "settings",    :limit => 2147483647
  end

  add_index "video_preset", ["name"], :name => "name", :unique => true

  create_table "video_queue", :primary_key => "vid", :force => true do |t|
    t.integer "fid",                              :default => 0,  :null => false
    t.integer "nid",                              :default => 0,  :null => false
    t.integer "status",                           :default => 0,  :null => false
    t.string  "dimensions",                       :default => ""
    t.string  "duration",   :limit => 32
    t.integer "started",                          :default => 0,  :null => false
    t.integer "completed",                        :default => 0,  :null => false
    t.binary  "data",       :limit => 2147483647
  end

  add_index "video_queue", ["fid"], :name => "file"
  add_index "video_queue", ["status"], :name => "status"

  create_table "video_thumbnails", :id => false, :force => true do |t|
    t.integer "vid",                              :null => false
    t.binary  "thumbnails", :limit => 2147483647
  end

  add_index "video_thumbnails", ["vid"], :name => "thumbnail"

  create_table "views_display", :id => false, :force => true do |t|
    t.integer "vid",                                   :default => 0,  :null => false
    t.string  "id",              :limit => 64,         :default => "", :null => false
    t.string  "display_title",   :limit => 64,         :default => "", :null => false
    t.string  "display_plugin",  :limit => 64,         :default => "", :null => false
    t.integer "position",                              :default => 0
    t.text    "display_options", :limit => 2147483647
  end

  add_index "views_display", ["vid", "position"], :name => "vid"

  create_table "views_view", :primary_key => "vid", :force => true do |t|
    t.string  "name",        :limit => 32, :default => "", :null => false
    t.string  "description",               :default => ""
    t.string  "tag",                       :default => ""
    t.string  "base_table",  :limit => 64, :default => "", :null => false
    t.string  "human_name",                :default => ""
    t.integer "core",                      :default => 0
  end

  add_index "views_view", ["name"], :name => "name", :unique => true

  create_table "watchdog", :primary_key => "wid", :force => true do |t|
    t.integer "uid",                             :default => 0,  :null => false
    t.string  "type",      :limit => 64,         :default => "", :null => false
    t.text    "message",   :limit => 2147483647,                 :null => false
    t.binary  "variables", :limit => 2147483647,                 :null => false
    t.integer "severity",  :limit => 1,          :default => 0,  :null => false
    t.string  "link",                            :default => ""
    t.text    "location",                                        :null => false
    t.text    "referer"
    t.string  "hostname",  :limit => 128,        :default => "", :null => false
    t.integer "timestamp",                       :default => 0,  :null => false
  end

  add_index "watchdog", ["type"], :name => "type"
  add_index "watchdog", ["uid"], :name => "uid"

  create_table "xmlsitemap", :id => false, :force => true do |t|
    t.integer "id",                               :default => 0,  :null => false
    t.string  "type",              :limit => 32,  :default => "", :null => false
    t.string  "subtype",           :limit => 128, :default => "", :null => false
    t.string  "loc",                              :default => "", :null => false
    t.string  "language",          :limit => 12,  :default => "", :null => false
    t.integer "access",            :limit => 1,   :default => 1,  :null => false
    t.integer "status",            :limit => 1,   :default => 1,  :null => false
    t.integer "status_override",   :limit => 1,   :default => 0,  :null => false
    t.integer "lastmod",                          :default => 0,  :null => false
    t.float   "priority"
    t.integer "priority_override", :limit => 1,   :default => 0,  :null => false
    t.integer "changefreq",                       :default => 0,  :null => false
    t.integer "changecount",                      :default => 0,  :null => false
  end

  add_index "xmlsitemap", ["access", "status", "loc"], :name => "access_status_loc"
  add_index "xmlsitemap", ["language"], :name => "language"
  add_index "xmlsitemap", ["loc"], :name => "loc"
  add_index "xmlsitemap", ["type", "subtype"], :name => "type_subtype"

  create_table "xmlsitemap_sitemap", :primary_key => "smid", :force => true do |t|
    t.text    "context",                     :null => false
    t.integer "updated",      :default => 0, :null => false
    t.integer "links",        :default => 0, :null => false
    t.integer "chunks",       :default => 0, :null => false
    t.integer "max_filesize", :default => 0, :null => false
  end

  add_foreign_key "news_rec", "node", name: "FK_recommendations_node", column: "news_id", primary_key: "nid"

  add_foreign_key "region_ip_sections", "regions", name: "FK_region_ip_sections_regions"

  add_foreign_key "region_sales", "regions", name: "FK_region_sales_regions"
  add_foreign_key "region_sales", "uc_products", name: "FK_region_sales_uc_products", column: "game_id", primary_key: "nid"

end

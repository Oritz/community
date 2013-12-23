class CreateGamePlatformUsers < ActiveRecord::Migration
  def change
    create_table :game_platform_users do |t|
      t.integer :game_platform_id, null: false
      t.string :game_platform_account, null: false
      t.integer :bind_count, null: false
      t.integer :game_count, null: false
      t.column :latest_time, "datetime"
      t.column :status, "tinyint", null: false
    end

    add_index :game_platform_users, [:game_platform_id, :game_platform_account], name: "uni_gau_id_account", unique: true
    add_index :game_platform_users, [:game_platform_id, :game_platform_account], name: "idx_gau_id_account"
    add_index :game_platform_users, :game_platform_account

    create_table :game_platform_users_games, id: false do |t|
      t.integer :game_platform_user_id, null: false
      t.integer :game_id, null: false
      t.integer :playtime_count, null: false
      t.integer :game_achievement_count, null: false
    end

    add_index :game_platform_users_games, [:game_platform_user_id, :game_id], name: "uni_game_platform_users_games_user_id_game_id", unique: true
    add_index :game_platform_users_games, [:game_platform_user_id, :game_id], name: "idx_game_platform_users_games_user_id_game_id"
    add_index :game_platform_users_games, :game_id

    create_table :game_platform_users_game_achievements, id: false do |t|
      t.integer :game_platform_user_id, null: false
      t.integer :game_achievement_id, null: false
      t.column :unlocked_at, "datetime"
    end

    add_index :game_platform_users_game_achievements, [:game_platform_user_id, :game_achievement_id], name: "uni_gpuga_user_id_achievement_id", unique: true
    add_index :game_platform_users_game_achievements, [:game_platform_user_id, :game_achievement_id], name: "idx_gpuga_user_id_achievement_id"
    add_index :game_platform_users_game_achievements, :game_achievement_id, name: "idx_gpuga_game_achievement_id"

    create_table :accounts_game_platform_users, id: false do |t|
      t.integer :account_id, null: false
      t.integer :game_platform_user_id, null: false

      t.timestamps
    end

    add_index :accounts_game_platform_users, [:account_id, :game_platform_user_id], name: "uni_accounts_game_platform_users_account_id_user_id", unique: true
    add_index :accounts_game_platform_users, [:account_id, :game_platform_user_id], name: "idx_accounts_game_platform_users_account_id_user_id"
    add_index :accounts_game_platform_users, :game_platform_user_id
  end
end

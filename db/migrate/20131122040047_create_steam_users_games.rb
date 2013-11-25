class CreateSteamUsersGames < ActiveRecord::Migration
  def change
    create_table :steam_users_games do |t|
      t.integer :steam_user_id, null: false
      t.integer :game_id, null: false
      t.integer :playtime_forever
      t.integer :playtime_2weeks
      t.column :has_community_visible_stats, "tinyint", null: false
    end

    add_index :steam_users_games, [:steam_user_id, :game_id], name: "uni_sug_sui_gi", unique: true
    add_index :steam_users_games, [:steam_user_id, :game_id], name: "idx_sug_sui_gi"
    add_index :steam_users_games, :game_id
  end
end

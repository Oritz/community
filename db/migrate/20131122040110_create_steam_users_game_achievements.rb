class CreateSteamUsersGameAchievements < ActiveRecord::Migration
  def change
    create_table :steam_users_game_achievements do |t|
      t.integer :steam_user_id, null: false
      t.integer :game_achievement_id, null: false

      t.timestamps
    end

    add_index :steam_users_game_achievements, [:steam_user_id, :game_achievement_id], name: "uni_suga_sui_gai", unique: true
    add_index :steam_users_game_achievements, [:steam_user_id, :game_achievement_id], name: "idx_suga_sui_gai"
    add_index :steam_users_game_achievements, :game_achievement_id
  end
end

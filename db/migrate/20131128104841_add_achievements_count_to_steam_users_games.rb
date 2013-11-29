class AddAchievementsCountToSteamUsersGames < ActiveRecord::Migration
  def up
    add_column :steam_users_games, :achievements_count, :integer, null: false
  end

  def down
    remove_column :steam_users_games, :achievements_count
  end
end

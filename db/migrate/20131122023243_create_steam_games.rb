class CreateSteamGames < ActiveRecord::Migration
  def change
    create_table :steam_games do |t|
      t.integer :appid, null: false
    end

    add_index :steam_games, :appid, name: "uni_steam_games_appid", unique: true
    add_index :steam_games, :appid, name: "idx_steam_games_appid"
  end
end

class CreateSteamGameAchievements < ActiveRecord::Migration
  def change
    create_table :steam_game_achievements do |t|
      t.string :api_name, null: false
      t.column :percent, "double"
      t.integer :steam_game_id, null: false
    end

    add_index :steam_game_achievements, [:steam_game_id, :api_name], name: "uni_sga_sgi_an", unique: true
    add_index :steam_game_achievements, [:steam_game_id, :api_name], name: "idx_sga_sgi_an"
    add_index :steam_game_achievements, :api_name
  end
end

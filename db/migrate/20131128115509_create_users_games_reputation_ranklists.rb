class CreateUsersGamesReputationRanklists < ActiveRecord::Migration
  def change
    create_table :users_games_reputation_ranklists do |t|
      t.integer :game_id, null: false
      t.integer :user_id, null: false
      t.string :user_type, null: false
      t.integer :reputation, null: false
      t.integer :delta_reputation, null: false
      t.column :rank, "tinyint", null: false
    end

    add_index :users_games_reputation_ranklists, [:user_id, :user_type, :game_id], name: "uni_ugrr_ui_ut_gi", unique: true
    add_index :users_games_reputation_ranklists, [:user_id, :user_type, :game_id], name: "idx_ugrr_ui_ut_gi"
    add_index :users_games_reputation_ranklists, :game_id
  end
end

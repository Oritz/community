class CreateAccountsOtherGames < ActiveRecord::Migration
  def up
    create_table :accounts_other_games, id: false do |t|
      t.integer :account_id, null: false
      t.integer :game_id, null: false
      t.integer :playtime_forever, null: false
      t.integer :playtime_2weeks, null: false
      t.integer :achievements_count, null: false
    end

    add_index :accounts_other_games, [:account_id, :game_id], name: "uni_aog_ai_gi", unique: true
    add_index :accounts_other_games, [:account_id, :game_id], name: "idx_aog_ai_gi"
    add_index :accounts_other_games, :game_id

    change_column :all_games, :subable_id, :integer, null: true
    change_column :all_games, :subable_type, :string, null: true
  end

  def down
    change_column :all_games, :subable_id, :integer, null: false
    change_column :all_games, :subable_type, :string, null: false

    drop_table :accounts_other_games
  end
end

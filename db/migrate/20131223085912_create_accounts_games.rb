class CreateAccountsGames < ActiveRecord::Migration
  def change
    create_table :accounts_games do |t|
      t.integer :account_id, null: false
      t.integer :game_id, null: false
      t.integer :accounts_order_id, null: false

      t.timestamps
    end

    add_index :accounts_games, [:account_id, :game_id], name: "idx_accounts_games_ai_gi"
    add_index :accounts_games, :game_id
    add_index :accounts_games, :accounts_order_id
  end
end

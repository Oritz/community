class CreateOrderGames < ActiveRecord::Migration
  def change
    create_table :order_games, id: false do |t|
      t.integer :order_id, null: false
      t.integer :account_id, null: false
      t.integer :game_id, null: false
      t.integer :drupal_account_id, null: false

      t.timestamps
    end

    add_index :order_games, [:account_id, :game_id, :order_id], name: "idx_order_games_ai_gi_oi"
  end
end

class CreateUserGamePlayHistories < ActiveRecord::Migration
  def change
    create_table :user_game_play_histories do |t|
      t.integer :account_id, null: false
      t.integer :game_id, null: false
      t.datetime :start_time, null: false
      t.datetime :exit_time
    end

    add_index :user_game_play_histories, [:account_id, :game_id], name: "idx_ugph_ai_gi"
    add_index :user_game_play_histories, :game_id
    add_index :user_game_play_histories, :start_time
    add_index :user_game_play_histories, :exit_time
  end
end

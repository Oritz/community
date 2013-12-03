class CreateUserGameSerials < ActiveRecord::Migration
  def change
    create_table :user_game_serials do |t|
      t.integer :account_id, null: false
      t.integer :game_id, null: false
      t.integer :serial_type, null: false
      t.string :serial_number, limit: 128, null: false
      t.timestamps
    end

    add_index :user_game_serials, :account_id
    add_index :user_game_serials, :game_id
    add_index :user_game_serials, :serial_type
  end
end

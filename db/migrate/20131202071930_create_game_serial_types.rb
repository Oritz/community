class CreateGameSerialTypes < ActiveRecord::Migration
  def change
    create_table :game_serial_types do |t|
      t.integer :game_id, null: false
      t.integer :serial_type, null: false
    end

    add_index :game_serial_types, [:game_id, :serial_type]
    add_index :game_serial_types, :serial_type
  end
end

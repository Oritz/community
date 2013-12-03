class CreateGameSerialNumbers < ActiveRecord::Migration
  def change
    create_table :game_serial_numbers do |t|
      t.integer :game_id, null: false
      t.integer :serial_type, null: false
      t.integer :batch_number, null: false
      t.string :serial_number, limit: 128, null: false
      t.column :status, "tinyint", null: false
      t.timestamps
    end

    add_index :game_serial_numbers, :game_id
    add_index :game_serial_numbers, :serial_type
    add_index :game_serial_numbers, [:game_id, :serial_type, :status]
  end
end

class CreateGameAchievements < ActiveRecord::Migration
  def change
    create_table :game_achievements do |t|
      t.integer :game_id, null: false
      t.string :name, null: false
      t.column :description, "text", null: false
      t.string :api_name, null: false
      t.string :lock_url, null: false
      t.string :unlock_url, null: false
      t.column :percentage, "double"
      t.column :status, "tinyint", null: false
      t.timestamps
    end

    add_index :game_achievements, [:game_id, :api_name], name: "uni_ga_game_id_api_name", unique: true
    add_index :game_achievements, [:game_id, :api_name], name: "idx_ga_game_id_api_name"
    add_index :game_achievements, :api_name
  end
end

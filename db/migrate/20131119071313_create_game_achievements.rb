class CreateGameAchievements < ActiveRecord::Migration
  def change
    create_table :game_achievements do |t|
      t.integer :game_id, null: false
      t.string :name, null: false
      t.column :description, "text", null: false
      t.string :lock_url, null: false
      t.string :unlock_url, null: false
      t.column :status, "tinyint", null: false
      t.integer :subable_id, null: false
      t.string :subable_type, null: false
      t.timestamps
    end

    add_index :game_achievements, :game_id
    add_index :game_achievements, [:subable_id, :subable_type], name: "idx_ga_si_st"
  end
end

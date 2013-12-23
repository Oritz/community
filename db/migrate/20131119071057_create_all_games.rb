class CreateAllGames < ActiveRecord::Migration
  def change
    create_table :all_games do |t|
      t.string :name, null: false
      t.column :status, "tinyint", null: false
      t.integer :subable_id, null: false
      t.string :subable_type, null: false

      t.timestamps
    end

    add_index :all_games, [:subable_id, :subable_type], name: "idx_all_games_si_st"
  end
end

class CreateAllGames < ActiveRecord::Migration
  def change
    create_table :all_games do |t|
      t.string :name, null: false
      t.column :game_type, "tinyint", null: false
      t.column :status, "tinyint", null: false

      t.timestamps
    end
  end
end

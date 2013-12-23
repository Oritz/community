class AlterGames < ActiveRecord::Migration
  def up
    rename_column :games, :game_type, :game_tag
    change_column :games, :game_tag, :string, null: false
    change_column :games, :install_type, :string, null: false
  end

  def down
    rename_column :games, :game_tag, :game_type
    change_column :games, :game_type, "tinyint", null: true
    change_column :games, :install_type, "tinyint", null: true
  end
end

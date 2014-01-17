class AlterGames < ActiveRecord::Migration
  def up
    rename_column :games, :game_type, :game_tag
    change_column :games, :game_tag, :string, null: false
    change_column :games, :install_type, :string, null: false
    remove_column :games, :cap_image
    remove_column :games, :sell_price
    remove_column :games, :list_price
    remove_column :games, :downloadable
  end

  def down
    rename_column :games, :game_tag, :game_type
    change_column :games, :game_type, "tinyint", null: true
    change_column :games, :install_type, "tinyint", null: true
    add_column :games, :sell_price, "decimal", null: false
    add_column :games, :list_price, "decimal", null: false
    add_column :games, :downloadable, :integer, null: false
    add_column :games, :cap_image, :string
  end
end

class AddColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :cap_image, :string
    add_column :games, :icon_image, :string
    add_column :games, :product_image, :string
    add_column :games, :rating, "decimal"
    add_column :games, :forum_addr, :string
    add_column :games, :install_type, "tinyint"
    add_column :games, :manual, :string
    add_column :games, :release_date, :integer
    add_column :games, :link, :string, limit: 1024
    add_column :games, :sell_price, "decimal", null: false
    add_column :games, :list_price, "decimal", null: false
    add_column :games, :downloadable, :integer, null: false
  end
end

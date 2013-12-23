class AddImageToAllGames < ActiveRecord::Migration
  def change
    add_column :all_games, :image, :string, null: false
  end
end

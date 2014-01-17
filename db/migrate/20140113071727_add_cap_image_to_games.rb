class AddCapImageToGames < ActiveRecord::Migration
  def change
    add_column :games, :cap_image, :string
  end
end

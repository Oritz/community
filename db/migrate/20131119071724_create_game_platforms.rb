class CreateGamePlatforms < ActiveRecord::Migration
  def change
    create_table :game_platforms do |t|
      t.string :name, limit: 31, null: false
      t.string :api_key
      t.column :platform_type, "tinyint"
    end

    add_index :game_platforms, :name, unique: true
  end
end

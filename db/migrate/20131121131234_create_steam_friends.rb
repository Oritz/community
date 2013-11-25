class CreateSteamFriends < ActiveRecord::Migration
  def change
    create_table :steam_friends do |t|
      t.integer :steam_user_id, null: false
      t.integer :friend_id, null: false
      t.column :friend_since, "timestamp", null: false
    end

    add_index :steam_friends, [:steam_user_id, :friend_id], name: "uni_steam_friends_sui_fi", unique: true
    add_index :steam_friends, [:steam_user_id, :friend_id], name: "idx_steam_friends_sui_fi"
    add_index :steam_friends, :friend_id
  end
end

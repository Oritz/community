class CreateSteamUsers < ActiveRecord::Migration
  def change
    create_table :steam_users do |t|
      t.integer :account_id
      t.string :steamid, limit: 63, null: false
      t.string :personaname
      t.string :profile_url
      t.string :avatar
      t.column :communityvisibilitystate, "tinyint"
      t.column :profilestate, "tinyint"
      t.integer :lastlogoff
      t.column :commentpermission, "tinyint"
      t.string :realname
      t.string :primaryclanid
      t.integer :timecreated
      t.string :loccountrycode, limit: 15
      t.string :locstatecode, limit: 15
      t.integer :loccityid
    end

    add_index :steam_users, :account_id
    add_index :steam_users, :steamid, name: "idx_steam_users_steamid"
    add_index :steam_users, :steamid, name: "uni_steam_users_steamid",  unique: true
  end
end

class CreateFriendship < ActiveRecord::Migration
  def change
    create_table :friendship do |t|
      t.integer :account_id, null: false
      t.integer :follower_id, null: false
      t.column :is_mutual, "tinyint", null: false, default: 0

      t.timestamps
    end

    add_index :friendship, [:account_id, :follower_id], name: "uni_friendship_account_id_follower_id", unique: true
    add_index :friendship, [:account_id, :follower_id], name: "idx_friendship_account_id_follower_id"
    add_index :friendship, :follower_id
  end
end

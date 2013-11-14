class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, limit: 31, null: false
      t.string :description, limit: 255, null: false
      t.integer :member_count, null: false, default: 0
      t.integer :creator_id, null: false
      t.column :group_type, "tinyint unsigned", null: false
      t.column :status, "tinyint unsigned", null: false
      t.string :logo, limit: 255, null: false

      t.timestamps
    end

    add_index :groups, :creator_id

    create_table :groups_accounts do |t|
      t.integer :group_id, null: false
      t.integer :account_id, null: false

      t.timestamps
    end

    add_index :groups_accounts, [:group_id, :account_id], name: "uni_groups_accounts_group_id_account_id", unique: true
    add_index :groups_accounts, [:group_id, :account_id], name: "idx_groups_accounts_group_id_account_id"
    add_index :groups_accounts, :account_id
  end
end

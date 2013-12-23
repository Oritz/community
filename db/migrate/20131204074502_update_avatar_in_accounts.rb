class UpdateAvatarInAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :avatar
    add_column :accounts, :avatar_id, :integer

    add_index :accounts, :avatar_id
  end

  def down
    remove_column :accounts, :avatar_id
    add_column :accounts, :avatar, :string, null: false, default: ""
  end
end

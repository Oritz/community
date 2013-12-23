class AddUpdateTagToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :update_tag, :integer
  end

  def down
    remove_column :accounts, :update_tag
  end
end

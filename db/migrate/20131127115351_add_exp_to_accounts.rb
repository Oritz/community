class AddExpToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :exp, :integer, null: false
    add_column :accounts, :bonus, :integer, null: false
  end

  def down
    remove_column :accounts, :exp
    remove_column :accounts, :bonus
  end
end

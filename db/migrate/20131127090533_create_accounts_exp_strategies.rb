class CreateAccountsExpStrategies < ActiveRecord::Migration
  def up
    create_table :accounts_exp_strategies, id: false do |t|
      t.integer :account_id, null: false
      t.integer :exp_strategy_id, null: false
      t.integer :period_count, null: false
      t.datetime :last_added_at
    end

    add_index :accounts_exp_strategies, [:account_id, :exp_strategy_id], name: "uni_aes_ai_esi", unique: true
    add_index :accounts_exp_strategies, [:account_id, :exp_strategy_id], name: "idx_aes_ai_esi"
    add_index :accounts_exp_strategies, :exp_strategy_id
  end

  def down
    drop_table :accounts_exp_strategies
  end
end

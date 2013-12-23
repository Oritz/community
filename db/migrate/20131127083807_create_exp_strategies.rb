class CreateExpStrategies < ActiveRecord::Migration
  def change
    create_table :exp_strategies do |t|
      t.string :name, null: false
      t.string :app_name, null: false
      t.column :period_type, "tinyint", null: false
      t.integer :time_limit
      t.integer :value, null: false
      t.integer :bonus, null: false
      t.column :status, "tinyint", null: false
      t.column :data, "blob"
    end

    add_index :exp_strategies, :name, name: "uni_exp_strategies_name", unique: true
    add_index :exp_strategies, :app_name, name: "uni_exp_strategies_app_name", unique: true
    add_index :exp_strategies, :name, name: "idx_exp_strategies_name"
    add_index :exp_strategies, :app_name, name: "idx_exp_strategies_app_name"
  end
end

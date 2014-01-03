class CreateTipoffs < ActiveRecord::Migration
  def change
    create_table :tipoffs do |t|
      t.integer :account_id, null: false
      t.integer :target_account_id, null: false
      t.integer :detail_id, null: false
      t.string :detail_type, null: false
      t.integer :reason_id, null: false
      t.column :status, "tinyint", null: false
      t.integer :censor_id, null: true
      t.integer :handling_id, null: true

      t.timestamps
    end

    add_index :tipoffs, :account_id
    add_index :tipoffs, :censor_id
    add_index :tipoffs, [:detail_type, :detail_id], name: "idx_tipoffs_detail_type_id"
    add_index :tipoffs, :reason_id
  end
end

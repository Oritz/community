class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :account_id, null: false
      t.string :user_ip
      t.string :payment_method, limit: 32
      t.column :subtotal, "decimal", null: false
      t.string :order_status, limit: 32, null: false

      t.timestamps
    end

    add_index :orders, :account_id
  end
end

class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :first_account_id, null: false
      t.integer :second_account_id, null: false

      t.timestamps
    end

    add_index :conversations, [:first_account_id, :second_account_id], name: "uni_conversations_first_account_id_second_account_id", unique: true
    add_index :conversations, [:first_account_id, :second_account_id], name: "idx_conversations_first_account_id_second_account_id"
    add_index :conversations, :second_account_id
  end
end

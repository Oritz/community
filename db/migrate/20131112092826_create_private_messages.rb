class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.integer :conversation_id, null: false
      t.string :content, limit: 255, null: false
      t.column :private_message_type, "tinyint", null: false
      t.column :read_at, "datetime"
      t.column :first_deleted_at, "datetime"
      t.column :second_deleted_at, "datetime"

      t.timestamps
    end

    add_index :private_messages, :conversation_id
  end
end

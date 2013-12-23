class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.integer :account_id, null: false
      t.column :action_type, "smallint", null: false
      t.string :object_name

      t.timestamps
    end

    add_index :user_actions, :account_id
    add_index :user_actions, :action_type
    add_index :user_actions, :object_name
  end
end

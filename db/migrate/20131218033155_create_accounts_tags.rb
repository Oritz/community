class CreateAccountsTags < ActiveRecord::Migration
  def change
    create_table :accounts_tags, id: false do |t|
      t.integer :account_id, null: false
      t.integer :tag_id, null: false
    end

    add_index :accounts_tags, [:account_id, :tag_id], name: "uni_accounts_tags_account_id_tag_id", unique: true
    add_index :accounts_tags, [:account_id, :tag_id], name: "idx_accounts_tags_account_id_tag_id"
    add_index :accounts_tags, :tag_id
  end
end

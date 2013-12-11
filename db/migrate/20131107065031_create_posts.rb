class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :account_id, null: false
      t.string :comment
      t.integer :privilege, null: false
      t.column :status, 'tinyint', null: false
      t.integer :comment_count, null: false, default: 0
      t.integer :recommend_count, null: false, default: 0
      t.integer :like_count, null: false, default: 0
      t.string :detail_type, null: false
      t.integer :detail_id, null: false

      t.timestamps
    end

    add_index :posts, :account_id
    add_index :posts, [:detail_id, :detail_type], name: "uni_posts_detail_id_type", unique: true
    add_index :posts, [:detail_id, :detail_type], name: "idx_posts_detail_id_type"

    create_table(:accounts_like_posts, id: false) do |t|
      t.integer :account_id, null: false
      t.integer :post_id, null: false
      t.timestamps
    end

    add_index :accounts_like_posts, [:account_id, :post_id], name: "uni_accounts_like_posts_account_id_post_id", unique: true
    add_index :accounts_like_posts, [:account_id, :post_id], name: "idx_accounts_like_posts_account_id_post_id"
    add_index :accounts_like_posts, :post_id
  end
end

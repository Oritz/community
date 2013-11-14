class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :account_id, null: false
      t.string 'comment'
      t.column 'post_type', 'tinyint', null: false
      t.integer 'privilege', null: false
      t.column 'status', 'tinyint', null: false
      t.integer 'comment_count', null: false, default: 0
      t.integer 'recommend_count', null: false, default: 0
      t.integer 'like_count', null: false, default: 0

      t.timestamps
    end

    add_index :posts, :account_id

    create_table(:accounts_like_posts, id: false) do |t|
      t.integer :account_id, null: false
      t.integer :post_id
      t.timestamps
    end

    add_index :accounts_like_posts, [:account_id, :post_id], name: "uni_accounts_like_posts_account_id_post_id", unique: true
    add_index :accounts_like_posts, [:account_id, :post_id], name: "idx_accounts_like_posts_account_id_post_id"
    add_index :accounts_like_posts, :post_id
  end
end

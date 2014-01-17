class RemoveTalks < ActiveRecord::Migration
  def up
    drop_table :talks
    drop_table :subjects
    rename_column :posts, :recommendation, :content
    remove_index :posts, name: "uni_posts_detail_id_type"
    remove_index :posts, name: "idx_posts_detail_id_type"
    remove_column :posts, :detail_type
    remove_column :posts, :detail_id
    add_column :posts, :post_type, "tinyint", null: false
    add_column :posts, :main_body, "text", null: true
    add_column :posts, :original_author_id, :integer, null: true

    add_index :posts, :original_author_id
  end

  def down
    create_table :talks do |t|
      t.string :content, limit: 140, null: false
    end
    create_table :subjects do |t|
      t.string :title, limit: 64, null: false
      t.string :content, limit: 140, null: false
      t.column :main_body, "text", null: false
    end
    rename_column :posts, :content, :recommendation
    add_column :posts, :detail_type, :string, null: true
    add_column :posts, :detail_id, :integer, null: true
    add_index :posts, [:detail_id, :detail_type], name: "uni_posts_detail_id_type", unique: true
    add_index :posts, [:detail_id, :detail_type], name: "idx_posts_detail_id_type"
    remove_column :posts, :post_type
    remove_column :posts, :main_body
    remove_column :posts, :original_author_id
  end
end

class AddRecommendInfoToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :original_id, :integer, null: true
    add_column :posts, :parent_id, :integer, null: true
    rename_column :posts, :comment, :recommendation
    change_column :posts, :detail_type, :string, null: true
    change_column :posts, :detail_id, :integer, null: true

    add_index :posts, :original_id
    add_index :posts, :parent_id

    drop_table :recommends
  end

  def down
    create_table :recommends do |t|
      t.string :content, limit: 140, null: false
      t.integer :original_id, null: false
      t.integer :parent_id, null: false
      t.integer :original_author_id, null: false
    end

    add_index :recommends, :original_id
    add_index :recommends, :parent_id
    add_index :recommends, :original_author_id

    rename_column :posts, :recommendation, :comment
    change_column :posts, :detail_type, :string, null: false
    change_column :posts, :detail_id, :integer, null: false
    remove_column :posts, :original_id
    remove_column :posts, :parent_id
  end
end

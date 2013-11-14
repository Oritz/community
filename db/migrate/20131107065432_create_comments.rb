class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :post_id, null: false
      t.integer :post_author_id, null: false
      t.integer :author_id, null: false
      t.string :comment, limit: 140, null: false
      t.integer :original_id
      t.integer :original_author_id
      t.column :status, "tinyint", null: false

      t.timestamps
    end

    add_index :comments, :post_id
    add_index :comments, :post_author_id
    add_index :comments, :author_id
    add_index :comments, :original_id
    add_index :comments, :original_author_id
  end
end

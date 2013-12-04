class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.integer :post_id, null: false
      t.integer :cloud_storage_id, null: false
      t.string :comment, limit: 31
    end

    add_index :post_images, :post_id
    add_index :post_images, :cloud_storage_id
  end
end

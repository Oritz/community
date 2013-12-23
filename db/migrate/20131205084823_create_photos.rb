class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :album_id, null: false
      t.integer :account_id, null: false
      t.integer :cloud_storage_id, null: false
      t.string :description, null: false
      t.column :status, "tinyint", null: false
      t.timestamps
    end

    add_index :photos, :album_id
    add_index :photos, :account_id
    add_index :photos, :cloud_storage_id
  end
end

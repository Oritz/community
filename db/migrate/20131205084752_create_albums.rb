class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :account_id, null: false
      t.string :name, limit: 31, null: false
      t.string :description, null: false
      t.integer :photos_count, null: false
      t.column :status, "tinyint", null: false
      t.column :album_type, "tinyint", null: false
      t.timestamps
    end

    add_index :albums, :account_id
  end
end

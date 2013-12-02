class CreateCloudStorages < ActiveRecord::Migration
  def change
    create_table :cloud_storages do |t|
      t.integer :account_id, null: false
      t.string :bucket_name, limit: 63, null: false
      t.string :key, limit: 63, null: false
      t.column :storage_type, "tinyint", null: false
      t.column :data, "blob"
      t.column :private, "tinyint", null: false
        
      t.timestamps
    end
    
    add_index :cloud_storages, :account_id   
  end
end

class OldSystemTables < ActiveRecord::Migration
  def up
    # client_errors
    create_table :client_errors do |t|
      t.integer :account_id, null: false
      t.column :err_msg, "text", null: false

      t.timestamps
    end

    add_index :client_errors, :account_id

    # client_updates
    create_table :client_updates do |t|
      t.column :major_ver, "smallint", null: false
      t.column :minor_ver, "smallint", null: false
      t.column :tiny_ver, "smallint", null: false
      t.string :patch_file
      t.string :patch_digest
      t.column :description, "text"
      t.string :full_pkg_file, null: false
      t.column :status, "tinyint", null: false
      t.string :full_pkg_digest

      t.timestamps
    end
  end

  def down
    drop_table :client_updates
    drop_table :client_errors
  end
end

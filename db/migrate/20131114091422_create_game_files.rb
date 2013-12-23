class CreateGameFiles < ActiveRecord::Migration
  def change
    create_table :game_files do |t|
      t.integer :game_id, null: false
      t.string :file_dir, null: false
      t.string :exe_path_name, null: false
      t.column :crypt_type, "tinyint", null: false
      t.column :launcher_ver, "smallint"
      t.string :game_key
      t.string :game_key_iv
      t.string :key_digest
      t.column :process_start_time, "datetime"
      t.column :process_finish_time, "datetime"
      t.column :process_result, "text"
      t.integer :patch_ver, null: false
      t.column :seed_content, "longblob"
      t.string :seed_digest
      t.column :file_size, "bigint"
      t.column :game_shell, "longblob", null: false
      t.integer :shell_ver, null: false
      t.string :shell_digest, null: false
      t.column :game_ini, "blob", null: false
      t.integer :ini_ver, null: false
      t.string :ini_digest, null: false
      t.column :status, "tinyint", null: false
      t.string :comment

      t.timestamps
    end

    add_index :game_files, :game_id
  end
end

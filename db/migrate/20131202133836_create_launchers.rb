class CreateLaunchers < ActiveRecord::Migration
  def change
    create_table :launchers do |t|
      t.column :crypt_type, "tinyint", null: false
      t.column :protector, "blob", null: false
      t.string :protect_cmd, null: false
      t.string :root_key, null: false
      t.string :root_key_iv, null: false
      t.string :key_digest, null: false
      t.column :launcher, "blob", null: false
      t.string :launcer_name, null: false
      t.string :launcer_digest, null: false
      t.string :launcher_cmd, null: false
      t.integer :ver, null: false
      t.timestamps
    end
  end
end

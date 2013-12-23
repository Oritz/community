class CreateUserEnvs < ActiveRecord::Migration
  def change
    create_table :user_envs do |t|
      t.integer :account_id, null: false
      t.string :machine_id, null: false
      t.string :os, null: false
      t.string :cpu, null: false
      t.integer :ram, null: false
      t.integer :hdd, null: false
      t.string :graphics_card, null: false
      t.column :screen_w, "smallint", null: false
      t.column :screen_h, "smallint", null: false
      t.string :mac_address, null: false
      t.column :dx_ver_major, "smallint", null: false
      t.column :dx_ver_minor, "smallint", null: false
      t.column :dx_ver_tiny, "smallint", null: false
      t.column :dot_net_ver_major, "smallint", null: false
      t.column :dot_net_ver_minor, "smallint", null: false
      t.column :dot_net_ver_tiny, "smallint", null: false
      t.column :vc_rt_ver_major, "smallint", null: false
      t.column :vc_rt_ver_minor, "smallint", null: false
      t.timestamps
    end

    add_index :user_envs, :account_id
  end
end

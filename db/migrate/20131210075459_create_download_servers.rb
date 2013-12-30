class CreateAdmin::DownloadServers < ActiveRecord::Migration
  def change
    create_table :download_servers do |t|
      t.string :server_ip, limit: 128, null: false
      t.string :comment
      t.timestamps
    end
  end
end

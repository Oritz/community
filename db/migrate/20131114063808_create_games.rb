class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :alias_name, null: false
      t.string :dir_name, null: false
      t.column :description, "longtext", null: false
      t.integer :parent_id
      t.column :type, "tinyint", null: false
      t.column :status, "tinyint", null: false

      t.timestamps
    end
  end
end

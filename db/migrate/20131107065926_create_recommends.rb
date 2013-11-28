class CreateRecommends < ActiveRecord::Migration
  def change
    create_table :recommends, id: false do |t|
      t.column :id, 'int(11) PRIMARY KEY'
      t.string :content, limit: 140, null: false
      t.integer :original_id, null: false
      t.integer :parent_id, null: false
      t.integer :original_author_id, null: false
    end

    add_index :recommends, :original_id
    add_index :recommends, :parent_id
    add_index :recommends, :original_author_id
  end
end

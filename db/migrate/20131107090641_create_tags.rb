class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.column :category, "tinyint", null: false
    end

    create_table :groups_tags, id: false do |t|
      t.integer :group_id, null: false
      t.integer :tag_id, null: false
    end

    add_index :groups_tags, [:group_id, :tag_id], name: "uni_groups_tags_group_id_tag_id", unique: true
    add_index :groups_tags, [:group_id, :tag_id], name: "idx_groups_tags_group_id_tag_id"
    add_index :groups_tags, :tag_id
  end
end

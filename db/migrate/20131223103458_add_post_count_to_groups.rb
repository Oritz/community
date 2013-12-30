class AddPostCountToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :talk_count, :integer, null: false
    add_column :groups, :subject_count, :integer, null: false
    add_column :groups, :recommend_count, :integer, null: false
  end
end

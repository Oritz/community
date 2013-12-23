class AdjustGroupIdInPostAndSubject < ActiveRecord::Migration
  def up
    remove_column :subjects, :group_id
    add_column :posts, :group_id, :integer

    add_index :posts, :group_id
  end

  def down
    add_column :subjects, :group_id, :integer
    add_index :subjects, :group_id

    remove_column :posts, :group_id
  end
end

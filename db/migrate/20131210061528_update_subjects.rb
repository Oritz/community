class UpdateSubjects < ActiveRecord::Migration
  def up
    change_column :subjects, :title, :string, limit: 64, null: true
    change_column :subjects, :content, "text", null: true
  end

  def down
    change_column :subjects, :title, :string, limit: 64, null: false
    change_column :subjects, :content, "text", null: false
  end
end

class AddAbstractToSubjects < ActiveRecord::Migration
  def up
    add_column :subjects, :main_body, "text", null: true
    change_column :subjects, :content, :string, limit: 140, null: true
  end

  def down
    change_column :subjects, :content, "text", null: true
    remove_column :subjects, :main_body
  end
end

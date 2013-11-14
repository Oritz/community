class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :title, limit: 64, null: false
      t.column :content, "text", null: false
      t.integer :group_id
    end

    add_index :subjects, :group_id
  end
end

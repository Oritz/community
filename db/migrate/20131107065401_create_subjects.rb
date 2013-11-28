class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects, id: false do |t|
      t.column :id, 'int(11) PRIMARY KEY'
      t.string :title, limit: 64, null: false
      t.column :content, "text", null: false
      t.integer :group_id
    end

    add_index :subjects, :group_id
  end
end

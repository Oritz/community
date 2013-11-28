class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks, id: false do |t|
      t.column :id, 'int(11) PRIMARY KEY'
      t.string :content, limit: 140, null: false
    end
  end
end

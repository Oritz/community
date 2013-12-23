class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.column :recommend_type, "tinyint", null: false
      t.column :weight, "tinyint", null: false
      t.column :sub_type, "tinyint"
      t.string :full_pic
      t.string :thumb_pic
      t.string :title
      t.column :comment, "text"
      t.string :link, null: false
      t.timestamps
    end
  end
end

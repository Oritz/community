class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :content, limit: 140, null: false
    end
  end
end

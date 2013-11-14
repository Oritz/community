class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :followed
      t.integer :commented
      t.integer :recommended
      t.integer :liked
      t.integer :mentioned
      t.integer :private_message
    end
end

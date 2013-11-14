class ErbacCreateAuth < ActiveRecord::Migration
  def change
    create_table(:auth_items) do |t|
      t.string	:name, null: false
      t.integer :auth_type
      t.text	:description
      t.text	:bizrule
      t.text	:data
    end

    create_table(:auth_item_children, id: false) do |t|
      t.integer	:parent_id, null: false
      t.integer :child_id, null: false
    end

    create_table(:auth_assignments) do |t|
      t.integer	:item_id, null: false
      t.integer :user_id, null: false
      t.text	:bizrule
      t.text	:data
    end

    add_index(:auth_items, :name, unique: true)
    add_index(:auth_item_children, [:parent_id, :child_id], unique: true)
    add_index(:auth_assignments, [:item_id, :user_id], unique: true)
  end
end

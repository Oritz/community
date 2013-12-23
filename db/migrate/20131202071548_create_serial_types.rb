class CreateSerialTypes < ActiveRecord::Migration
  def change
    create_table :serial_types do |t|
      t.string :type_name, limit: 64, null: false
      t.string :type_desc, null: false
      t.column :type_cat, "smallint", null: false
    end

    add_index :serial_types, :type_name, name: "idx_serial_types_type_name"
    add_index :serial_types, :type_name, name: "uni_serial_types_type_name", unique: true
  end
end

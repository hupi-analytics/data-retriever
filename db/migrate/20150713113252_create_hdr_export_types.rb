class CreateHdrExportTypes < ActiveRecord::Migration
  def change
    create_table :hdr_export_types do |t|
      t.string :name
      t.string :desc
      t.string :render_types, array: true
      t.timestamps null: false
    end
    add_index :hdr_export_types, :name, unique: true
    add_index :hdr_export_types, :render_types, using: "gin"
  end
end

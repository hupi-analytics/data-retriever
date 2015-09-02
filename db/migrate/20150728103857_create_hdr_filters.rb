class CreateHdrFilters < ActiveRecord::Migration
  def change
    create_table :hdr_filters do |t|
      t.string :name
      t.string :pattern
      t.string :default_operator
      t.string :field
      t.references :hdr_query_object, index: true
      t.timestamps null: false
    end
    add_index :hdr_filters, :name
    add_index :hdr_filters, :pattern
    add_foreign_key :hdr_filters, :hdr_query_objects, on_delete: :cascade
  end
end

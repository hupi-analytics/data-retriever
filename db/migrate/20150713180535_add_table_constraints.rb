class AddTableConstraints < ActiveRecord::Migration
  def change
    add_foreign_key :hdr_query_objects, :hdr_endpoints, on_delete: :cascade
    add_foreign_key :hdr_query_objects, :hdr_query_engines, on_delete: :cascade
    add_foreign_key :hdr_query_objects_export_types, :hdr_query_objects, on_delete: :cascade
    add_foreign_key :hdr_query_objects_export_types, :hdr_export_types, on_delete: :cascade
  end
end

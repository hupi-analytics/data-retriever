class CreateHdrQueryObjectsExportTypes < ActiveRecord::Migration
  def change
    create_table :hdr_query_objects_export_types do |t|
      t.references :hdr_query_object, index: true
      t.references :hdr_export_type, index: true
      t.timestamps null: false
    end
  end
end

class CreateHdrQueryObjects < ActiveRecord::Migration
  def change
    create_table :hdr_query_objects do |t|
      t.string :name
      t.string :desc
      t.text :query
      t.timestamps null: false
      t.references :hdr_endpoint, index: true
      t.references :hdr_query_engine, index: true
    end
    add_index :hdr_query_objects, :name
  end
end

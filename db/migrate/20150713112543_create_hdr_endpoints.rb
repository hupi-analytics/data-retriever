class CreateHdrEndpoints < ActiveRecord::Migration
  def change
    create_table :hdr_endpoints do |t|
      t.string :module_name
      t.string :method_name
      t.timestamps null: false
    end
    add_index :hdr_endpoints, [:module_name, :method_name], unique: true
  end
end

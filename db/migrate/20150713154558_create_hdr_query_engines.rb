class CreateHdrQueryEngines < ActiveRecord::Migration
  def change
    create_table :hdr_query_engines do |t|
      t.string :name
      t.string :desc
      t.string :engine
      t.json :settings
      t.timestamps null: false
    end
    add_index :hdr_query_engines, :name, unique: true
  end
end

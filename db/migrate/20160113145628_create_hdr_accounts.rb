class CreateHdrAccounts < ActiveRecord::Migration
  def change
    create_table :hdr_accounts, id: :uuid do |t|
      t.string :name
      t.string :role
      t.string :access_token
      t.timestamps null: false
    end
    add_index :hdr_accounts, :name, unique: true
  end
end

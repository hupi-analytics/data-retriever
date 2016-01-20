class AddTokenIndexToAccounts < ActiveRecord::Migration
  def change
    add_index :hdr_accounts, :access_token, unique: true
  end
end

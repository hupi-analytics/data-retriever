class AddAccountToHdrEndpoints < ActiveRecord::Migration
  def change
    add_column :hdr_endpoints, :hdr_account_id, :uuid
    add_foreign_key :hdr_endpoints, :hdr_accounts, on_delete: :cascade
  end
end

class AddAccountToHdrQueryEngine < ActiveRecord::Migration
  def change
    add_column :hdr_query_engines, :hdr_account_id, :uuid
    add_foreign_key :hdr_query_engines, :hdr_accounts, on_delete: :cascade
  end
end

class AddApiToEndpoints < ActiveRecord::Migration
  def change
    add_column :hdr_endpoints, :api, :boolean, default: false
  end
end

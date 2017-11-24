class AddDescriptionToApiEndpoints < ActiveRecord::Migration
  def change
    add_column :hdr_endpoints, :description, :text
  end
end

class AddTypeToHdrFilter < ActiveRecord::Migration
  def change
    add_column :hdr_filters, :value_type, :string, default: "int"
    change_column_default :hdr_filters, :value_type, "int"
  end
end

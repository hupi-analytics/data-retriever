class HdrQueryObjectsExportType < ActiveRecord::Base
  belongs_to :hdr_query_object
  belongs_to :hdr_export_type
  validates :hdr_query_object, presence: true
  validates :hdr_export_type, presence: true
end

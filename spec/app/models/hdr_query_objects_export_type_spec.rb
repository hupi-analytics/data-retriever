RSpec.describe HdrQueryObjectsExportType, type: :model do
  it { is_expected.to belong_to :hdr_query_object }
  it { is_expected.to belong_to :hdr_export_type }
  it { is_expected.to validate_presence_of :hdr_query_object }
  it { is_expected.to validate_presence_of :hdr_export_type }
end

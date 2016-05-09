require "spec_helper"

RSpec.describe HdrExportType, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:hdr_query_objects_export_types) }
  it { is_expected.to validate_uniqueness_of :name }

  describe "when on create" do
    it "should add name to render types" do
      et = create(:hdr_export_type, :csv)
      expect(et.render_types).to include(et.name)
    end
  end
end

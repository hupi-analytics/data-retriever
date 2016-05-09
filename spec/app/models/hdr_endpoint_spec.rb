require "spec_helper"

RSpec.describe HdrEndpoint, type: :model do
  it { is_expected.to validate_presence_of :module_name }
  it { is_expected.to validate_presence_of :method_name }
  it { is_expected.to have_many :hdr_query_objects }
  it { is_expected.to have_many :hdr_export_types }
  it { is_expected.to validate_uniqueness_of(:method_name).scoped_to(:module_name) }

  describe "when multiple export_type'" do
    let!(:hdr_endpoint) { create(:hdr_endpoint) }
    it "should have accesible export_type" do
      expect(hdr_endpoint.render_types).to include("csv")
      expect(hdr_endpoint.render_types).to include("column_stacked_normal")
    end
  end
end

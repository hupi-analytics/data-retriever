RSpec.describe HdrQueryEngine, type: :model do
  it { is_expected.to have_many :hdr_query_objects }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :engine }
  it { is_expected.to validate_uniqueness_of :name }
  it "should init query_engine" do |variable|
    qe = build(:hdr_query_engine, :postgres)
    expect(qe.init).to be_kind_of(DefaultQueryEngine)
  end
end

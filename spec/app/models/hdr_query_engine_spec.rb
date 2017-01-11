require "spec_helper"

RSpec.describe HdrQueryEngine, type: :model do
  it { is_expected.to have_many :hdr_query_objects }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :engine }
  it { is_expected.to validate_uniqueness_of :name }
  it "should init query_engine" do
    qe = build(:hdr_query_engine, :csv)
    expect(qe.init("test")).to be_kind_of(DefaultQueryEngine)
  end

  it "should not allow delete query_engine if query object is present" do
    qe = create(:hdr_query_engine, :csv)
    create(:hdr_query_object, :csv, hdr_query_engine_id: qe.id)
    expect{qe.destroy}.to raise_error(ActiveRecord::ActiveRecordError)
  end

  it "should allow delete query_engine if no query object is present" do
    qe = create(:hdr_query_engine, :csv)
    create(:hdr_query_object, :csv)
    expect{qe.destroy}.not_to raise_error
  end
end

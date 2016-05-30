require "spec_helper"

RSpec.describe HdrFilter, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :pattern }
  it { is_expected.to validate_presence_of :default_operator }
  it { is_expected.to validate_presence_of :field }
  it { is_expected.to belong_to(:hdr_query_object) }
end

RSpec.describe HdrQueryObject, type: :model do
  it { is_expected.to validate_presence_of :query }
  it { is_expected.to have_many :hdr_query_objects_export_types }
  it { is_expected.to have_many :hdr_export_types }
  it { is_expected.to belong_to :hdr_query_engine }
  it { is_expected.to belong_to :hdr_endpoint }

  describe "when call render_types" do
    let(:query) { create(:hdr_query_object, :two_export_type) }
    it "should include csv" do
      expect(query.render_types).to include('csv')
    end

    it "should include column_stacked_normal" do
      expect(query.render_types).to include("column_stacked_normal")
    end
  end

  describe "when call get_filters" do
    let(:query) { create(:hdr_query_object, :csv, :date_filters) }
    let(:filter_params) do
      {
        start_date: '20150101',
        end_date: { operator: '<=', value: '20151231' },
        unvalid_filter: 'toto'
      }
    end
    let(:filter_array) do
      {
        'where_f1' => [
          { operator: '<=', value: '20151231', field: 'entity_createat_int', value_type: 'int' },
          { operator: '>', value: '20150101', field: 'entity_createat_int', value_type: 'int' }
        ]
      }
    end

    it "should return an array of filters" do
      expect(query.get_filters(filter_params)['where_f1']).to match_array(filter_array['where_f1'])
    end
  end

  describe "when call get_filters with nil value" do
    let(:query) { create(:hdr_query_object, :csv, :date_filters) }
    let(:filter_params) do
      {
        start_date: nil,
        end_date: { operator: '<=', value: nil },
        unvalid_filter: 'toto'
      }
    end
    let(:filter_array) { { 'where_f1' => [] } }

    it "should return an empty array of filters" do
      expect(query.get_filters(filter_params)['where_f1']).to match_array(filter_array['where_f1'])
    end
  end

  describe "when call get_filters with empty value" do
    let(:query) { create(:hdr_query_object, :csv, :date_filters) }
    let(:filter_params) do
      {
        start_date: '',
        end_date: { operator: '<=', value: '' },
        unvalid_filter: 'toto'
      }
    end
    let(:filter_array) { { 'where_f1' => [] } }

    it "should return an empty array of filters" do
      expect(query.get_filters(filter_params)['where_f1']).to match_array(filter_array['where_f1'])
    end
  end
end

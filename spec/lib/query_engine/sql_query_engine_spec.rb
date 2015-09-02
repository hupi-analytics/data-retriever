require "spec_helper"

describe SQLQueryEngine do
  let(:qe){ SQLQueryEngine.new({}) }
  let(:where_query) { "select * from #_client_#.entitystatstable #_where_f1_#" }
  let(:and_query) { 'select * from #_client_#.entitystatstable WHERE entity_type="customer" #_and_f1_#' }
  let(:filter_array) do
    {
      "where_f1" => [
        { operator: ">", value: "20150101", field: "entity_createat_int" },
        { operator: "<=", value: "20151231", field: "entity_createat_int" }
      ],
      "and_f1" => [
        { operator: ">", value: "20150101", field: "entity_createat_int" },
        { operator: "<=", value: "20151231", field: "entity_createat_int" }
      ]
    }
  end

  let(:empty_filter_array) do
    {
      "where_f1" => [],
      "and_f1" => []
    }
  end

  describe "apply_filters" do
    let(:where_query_res) do
      "select * from #_client_#.entitystatstable WHERE entity_createat_int > 20150101 AND entity_createat_int <= 20151231"
    end
    let(:and_query_res) do
      'select * from #_client_#.entitystatstable WHERE entity_type="customer" AND entity_createat_int > 20150101 AND entity_createat_int <= 20151231'
    end

    context "with filters" do
      it { expect(qe.apply_filters(where_query, filter_array)).to eq(where_query_res) }
      it { expect(qe.apply_filters(and_query, filter_array)).to eq(and_query_res) }
    end

    context "without filters" do
      it { expect(qe.apply_filters(where_query)).to eq("select * from #_client_#.entitystatstable ") }
      it { expect(qe.apply_filters(and_query)).to eq('select * from #_client_#.entitystatstable WHERE entity_type="customer" ') }
    end

    context "with empty filters" do
      it { expect(qe.apply_filters(where_query, empty_filter_array)).to eq("select * from #_client_#.entitystatstable ") }
      it { expect(qe.apply_filters(and_query, empty_filter_array)).to eq('select * from #_client_#.entitystatstable WHERE entity_type="customer" ') }
    end
  end

  describe "decorate query" do
    let(:where_query_res) do
      "select * from hdr_test.entitystatstable WHERE entity_createat_int > 20150101 AND entity_createat_int <= 20151231"
    end
    let(:and_query_res) do
      'select * from hdr_test.entitystatstable WHERE entity_type="customer" AND entity_createat_int > 20150101 AND entity_createat_int <= 20151231'
    end
    let(:where_query_res1) do
      "select * from hdr_test.entitystatstable "
    end
    let(:and_query_res1) do
      'select * from hdr_test.entitystatstable WHERE entity_type="customer" '
    end

    it { expect(qe.decorate(where_query, "hdr_test", filter_array)).to eq(where_query_res) }
    it { expect(qe.decorate(and_query, "hdr_test", filter_array)).to eq(and_query_res) }
    it { expect(qe.decorate(where_query, "hdr_test", {})).to eq(where_query_res1) }
    it { expect(qe.decorate(and_query, "hdr_test", {})).to eq(and_query_res1) }

  end
end

require "spec_helper"

describe SQLQueryEngine do
  let(:qe){ SQLQueryEngine.new("hdr_test", {}) }
  let(:where_query) { "select * from #_client_#.entitystatstable #_where_f1_#" }
  let(:and_query) { "select * from #_client_#.entitystatstable WHERE entity_type='customer' #_and_f1_#" }
  let(:and_query_with_params) { "select * from #_client_#.entitystatstable WHERE entity_type='#_value_#' #_and_f1_#" }
  let(:filter_array) do
    {
      "where_f1" => [
        { operator: ">", value: "20150101", field: "entity_createat_int", value_type: "int" },
        { operator: "<=", value: "20151231", field: "entity_createat_int", value_type: "int" },
        { operator: "=", value: "paul", field: "entity_name", value_type: "string" }
      ],
      "and_f1" => [
        { operator: ">", value: "20150101", field: "entity_createat_int", value_type: "int" },
        { operator: "<=", value: "20151231", field: "entity_createat_int", value_type: "int" }
      ]
    }
  end

  let(:empty_filter_array) do
    {
      "where_f1" => [],
      "and_f1" => []
    }
  end

  describe "decorate query" do
    let(:where_query_res) do
      "select * from hdr_test.entitystatstable WHERE (entity_createat_int > 20150101) AND (entity_createat_int <= 20151231) AND (entity_name = 'paul')"
    end
    let(:and_query_res) do
      "select * from hdr_test.entitystatstable WHERE entity_type='customer' AND (entity_createat_int > 20150101) AND (entity_createat_int <= 20151231)"
    end
    let(:where_query_res1) do
      "select * from hdr_test.entitystatstable "
    end
    let(:and_query_res1) do
      "select * from hdr_test.entitystatstable WHERE entity_type='customer' "
    end
    let(:and_query_with_params) do
      "select * from hdr_test.entitystatstable WHERE entity_type='customer' AND (entity_createat_int > 20150101) AND (entity_createat_int <= 20151231)"
    end

    it { expect(qe.decorate(where_query, filter_array)).to eq(where_query_res) }
    it { expect(qe.decorate(and_query, filter_array)).to eq(and_query_res) }
    it { expect(qe.decorate(where_query, {})).to eq(where_query_res1) }
    it { expect(qe.decorate(and_query, {})).to eq(and_query_res1) }
    it { expect(qe.decorate(and_query_with_params, filter_array, value: "customer")).to eq(and_query_with_params) }
  end
end

require "spec_helper"

describe ElasticsearchQueryEngine do
  let(:qe) { ElasticsearchQueryEngine.new("test_client", {}) }
  let(:sub_query) do
    <<-REQ.gsub(/^ {4}/, "")
    {
      "index": "wikicampers_vehicle",
      "body": {
        "query": {
          "bool": {
            "should": [
              #_sub_should_#
            ]
          },
          "function_score": {
            "functions": [
              #_sub_and_function_#
              {
                "exp": {
                  "acceptance_rate": {
                    "origin": 1,
                    "offset": 0,
                    "scale": 0.5
                  }
                },
                "weight": 1
              }
            ]
          }
        }
      }
    }
    REQ
  end
  let(:filter_array) do
    {
      "sub_should" => [
        { operator: '{ "match": { "type": #_value_#, "boost": 1 } }', value: "capucine", field: "type", value_type: "string" },
        { operator: '{ "match": { "vehicle_options": #_value_#, "boost": 1 } }', value: '["opt1","opt2"]', field: "opt", value_type: "array" }
      ],
      "sub_and_function" => [
        { operator: '{ "gauss": { "geoloc": { "origin": #_value_#, "offset": "50km", "scale": "25km" } }, "weight": 1}', value: '{"lat": 43.2, "long": 1.2}', field: "geoloc", value_type: "hash" },
        { operator: '{ "linear": { "nombre_place": { "origin": #_value_#, "offset": 1, "scale": 2 } }, "weight": 1}', value: 4, field: "nombre_place", value_type: "int" }
      ]
    }
  end

  let(:empty_filter_array) do
    {
      "sub_should" => [],
      "sub_and_function" => []
    }
  end

  context "decorate" do
    describe "for sub" do
      context "with filters" do
        let(:sub_query_res) do
          {
            index: "wikicampers_vehicle",
            body: {
              query: {
                bool: {
                  should: [
                    { match: { type: "capucine", boost: 1 } },
                    { match: { vehicle_options: ["opt1", "opt2"], boost: 1 } }
                  ]
                },
                function_score: {
                  functions: [
                    {
                      gauss: {
                        geoloc: {
                          origin: { lat: 43.2, long: 1.2 },
                          offset: "50km",
                          scale: "25km"
                        }
                      },
                      weight: 1
                    },
                    {
                      linear: {
                        nombre_place: {
                          origin: 4,
                          offset: 1,
                          scale: 2
                        }
                      },
                      weight: 1
                    },
                    {
                      exp: {
                        acceptance_rate: {
                          origin: 1,
                          offset: 0,
                          scale: 0.5
                        }
                      },
                      weight: 1
                    }
                  ]
                }
              }
            }
          }
        end

        it { expect(qe.decorate(sub_query, filter_array)).to eq(sub_query_res) }
      end

      context "without filters" do
        let(:sub_query_res) do
          {
            index: "wikicampers_vehicle",
            body: {
              query: {
                bool: {
                  should: []
                },
                function_score: {
                  functions: [
                    {
                      exp: {
                        acceptance_rate: {
                          origin: 1,
                          offset: 0,
                          scale: 0.5
                        }
                      },
                      weight: 1
                    }
                  ]
                }
              }
            }
          }
        end

        it { expect(qe.decorate(sub_query)).to eq(sub_query_res) }
      end

      context "with empty filters" do
        let(:sub_query_res) do
          {
            index: "wikicampers_vehicle",
            body: {
              query: {
                bool: {
                  should: []
                },
                function_score: {
                  functions: [
                    {
                      exp: {
                        acceptance_rate: {
                          origin: 1,
                          offset: 0,
                          scale: 0.5
                        }
                      },
                      weight: 1
                    }
                  ]
                }
              }
            }
          }
        end

        it { expect(qe.decorate(sub_query, empty_filter_array)).to eq(sub_query_res) }
      end
    end
  end
end

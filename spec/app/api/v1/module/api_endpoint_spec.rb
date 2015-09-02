require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:endpoint_test) { FactoryGirl.create(:hdr_endpoint) }
  let(:client) { "hdr_test_data" }

  describe "POST test" do
    let(:url) { "#{endpoint_test.module_name}/#{endpoint_test.method_name}" }

    it_behaves_like "error in client parameters"

    context "when wrong render_type parameters" do
      it "return an error" do
        post url, client: client, render_type: "not_a_chart"
        expect(response.status).to eq(400)
        expect_json(error: regex("render_type should be one of:"))
      end
    end

    context "when no render_type parameters" do
      it "return an error" do
        post url, client: client
        expect(response.status).to eq(400)
        expect_json(error: regex("render_type is missing"))
      end
    end

    context "when wrong routes" do
      let(:url) { "wrong/route" }
      it "return an error" do
        post url, client: client, render_type: "not_a_chart"
        expect(response.status).to eq(404)
        expect_json(error: regex("url not found: #{url}"))
      end
    end

    context "when render_type = csv" do
      let(:res) do
        {
          data: {
            rows: [
              ["manufacturer1", true, 1, "college1", "", 2014_01_01, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer2", true, 14, "college1", "", 2014_02_02, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer3", false, 0, "college1", "", nil, 2014_01_01, 1.0, 2.0, "supplier"],
              ["client1", false, 10, "college2", "homme", nil, 2014_01_01, 1.0, 2.0, "customer"],
              ["client2", true, 5, "college2", "homme", 2014_01_01, 2014_01_01, 1.0, 2.0, "customer"],
              ["client3", true, 1, "college2", "homme", 2014_02_02, 2014_01_01, 1.0, 2.0, "customer"],
              ["client4", true, 5, "college2", "homme", 2014_03_03, 2014_02_02, 1.0, 2.0, "customer"],
              ["client5", true, 2, "college2", "femme", 2014_04_04, 2014_02_02, 1.0, 2.0, "customer"],
              ["client6", false, 10, "college2", "femme", nil, 2014_03_03, 1.0, 2.0, "customer"],
              ["client7", true, 1, "college2", "femme", 2014_05_05, 2014_03_03, 1.0, 2.0, "customer"],
              ["client8", true, 1, "college2", "femme", 2014_06_06, 2014_04_04, 1.0, 2.0, "customer"]
            ],
            header: %w(entity_name memberof_valid memberof_share_quantity memberof_name entity_gender memberof_memberfromint entity_createat_int entity_latitude entity_longitude entity_type)
          }
        }
      end

      it "returns 'csv json' format" do
        post url, client: client, render_type: "csv"
        expect_json(res)
      end
    end

    context "with filter" do
      let(:res) do
        {
          data: {
            categories: %w(college2),
            series: [
              { name: "femme", data: [2] },
              { name: "homme", data: [5] }
            ]
          }
        }
      end
      let(:filters) do
        {
          start_date: 2014_01_01,
          end_date: { operator: "<=", value: 2014_02_02 }
        }
      end
      it "return filtered data" do
        post url, client: client, render_type: "column_stacked_normal", filters: filters
        expect_json(res)
      end
    end

    context "when render_type = column_stacked_normal" do
      let(:res) do
        {
          data: {
            categories: %w(college1 college2),
            series: [
              { name: "none", data: [15, 0] },
              { name: "femme", data: [0, 14] },
              { name: "homme", data: [0, 21] }
            ]
          }
        }
      end

      it "returns 'category serie value' format" do
        post url, client: client, render_type: "column_stacked_normal"
        expect_json(res)
      end
    end
  end
end

require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:hdr_endpoint_test) { FactoryGirl.create(:hdr_endpoint) }
  describe "GET hdr_endpoints" do
    let(:url) { "admin/hdr_endpoints" }

    before(:all) do
      4.times { FactoryGirl.create(:hdr_endpoint) }
    end

    context "when read all hdr_endpoint" do
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrEndpoint.count)
      end
    end

    context "when filter all hdr_endpoint" do
      let(:url) { "admin/hdr_endpoints?filters[module_name]=#{hdr_endpoint_test.module_name}" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(1)
      end
    end

    context "when order all hdr_endpoint" do
      let(:url) { "admin/hdr_endpoints?order[module_name]=DESC" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrEndpoint.count)
      end
    end
  end

  describe "GET hdr_endpoint" do
    context "when read existing hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/#{hdr_endpoint_test.id}" }
      let(:res) do
        hdr_endpoint_test.attributes
          .except!("created_at", "updated_at")
          .symbolize_keys!
      end
      it "return object" do
        get url
        expect(response.status).to eq(200)
        expect_json(res)
      end
    end

    context "when read unexisting hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/0" }

      it "return an error" do
        get url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrEndpoint"))
      end
    end
  end

  describe "POST hdr_endpoint" do
    let(:url) { "admin/hdr_endpoint" }

    context "when create valid hdr_endpoint" do
      let(:new_hdr_endpoint) { attributes_for(:hdr_endpoint) }

      it "return object" do
        post url, hdr_endpoint: new_hdr_endpoint
        expect(response.status).to eq(201)
        expect_json(new_hdr_endpoint)
      end

      describe "hdr_endpoint create" do
        subject { -> { post url, hdr_endpoint: new_hdr_endpoint } }
        it { should change(HdrEndpoint, :count).by(1) }
      end
    end

    context "when create valid hdr_endpoint with nested attributes" do
      let(:new_hdr_endpoint) do
        query = attributes_for(:hdr_query_object, hdr_query_engine_id: HdrQueryEngine.first.id,
                                              hdr_export_type_ids: [HdrExportType.first.id, HdrExportType.last.id])
        attributes_for(:hdr_endpoint, hdr_query_objects_attributes: [query, query])
      end

      it "return OK" do
        post url, hdr_endpoint: new_hdr_endpoint
        expect(response.status).to eq(201)
      end

      describe "hdr_endpoint creation" do
        subject { -> { post url, hdr_endpoint: new_hdr_endpoint } }
        it { should change(HdrEndpoint, :count).by(1) }
        it { should change(HdrQueryObject, :count).by(2) }
        it { should change(HdrQueryObjectsExportType, :count).by(4) }
      end
    end

    context "when create already existing hdr_endpoint" do
      let(:invalid_new_hdr_endpoint) { hdr_endpoint_test.attributes.except!("id", "created_at", "updated_at") }

      it "return an error" do
        post url, hdr_endpoint: invalid_new_hdr_endpoint
        expect(response.status).to eq(409)
        expect_json(error: regex("Validation failed"))
      end
    end
  end

  describe "PUT hdr_endpoint" do
    let(:update_hdr_endpoint) { attributes_for(:hdr_endpoint) }

    context "when update existing hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/#{hdr_endpoint_test.id}" }

      it "return object" do
        put url, hdr_endpoint: update_hdr_endpoint
        expect(response.status).to eq(200)
        expect_json(update_hdr_endpoint)
      end
    end

    context "when update unexisting hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/0" }

      it "return an error" do
        put url, hdr_endpoint: update_hdr_endpoint
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrEndpoint"))
      end
    end

    context "when update existing hdr_endpoint with hdr_query_object" do
      let(:url) { "admin/hdr_endpoint/#{hdr_endpoint_test.id}" }
      let(:update_hdr_endpoint) do
        {
          :module_name => "update_module",
          :method_name => "update_method",
          :hdr_query_objects_attributes => [
            {
              id: hdr_endpoint_test.hdr_query_objects.first.id,
              name: "updated_name"
            }
          ]
        }
      end

      it "update endpoint" do
        put url, hdr_endpoint: update_hdr_endpoint
        expect(response.status).to eq(200)
        resp = JSON.parse(response.body)
        expect(resp["module_name"]).to eq(update_hdr_endpoint[:module_name])
        expect(resp["method_name"]).to eq(update_hdr_endpoint[:method_name])
      end

      it "update query object name" do
        put url, hdr_endpoint: update_hdr_endpoint
        expect(response.status).to eq(200)
        query_resp = {}
        JSON.parse(response.body)["hdr_query_objects"].each do |q|
          query_resp = q if q["id"] == hdr_endpoint_test.hdr_query_objects.first.id
        end
        expect(query_resp["name"]).to eq(update_hdr_endpoint[:hdr_query_objects_attributes].first[:name])
      end
    end
  end

  describe "DELETE hdr_endpoint" do
    context "when delete hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/#{hdr_endpoint_test.id}" }

      it "return object" do
        delete url
        expect(response.status).to eq(200)
        expect { HdrEndpoint.find(hdr_endpoint_test.id) }.to raise_exception
      end

      describe "hdr_endpoint delete" do
        subject { -> { delete url } }
        it { should change(HdrEndpoint, :count).by(-1) }
        it { should change(HdrQueryObject, :count).by(-2) }
        it { should change(HdrQueryObjectsExportType, :count).by(-2) }
      end
    end

    context "when delete unexisting hdr_endpoint" do
      let(:url) { "admin/hdr_endpoint/0" }

      it "return an error" do
        delete url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrEndpoint"))
      end
    end
  end
end

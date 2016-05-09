require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:account) { FactoryGirl.create(:hdr_account) }
  let(:client) { "hdr_test" }
  let!(:public_endpoint) { FactoryGirl.create(:hdr_endpoint) }
  let!(:private_endpoint) { FactoryGirl.create(:hdr_endpoint, hdr_account: account) }
  let!(:private_endpoint) { FactoryGirl.create(:hdr_endpoint, hdr_account: account) }

  describe "POST private endpoint" do
    let(:url) { "private/#{private_endpoint.module_name}/#{private_endpoint.method_name}" }

    it_behaves_like "error in client parameters"

    context "when wrong render_type parameters" do
      it "return an error" do
        post url, client: client, render_type: "not_a_chart", token: account.access_token
        expect(response.status).to eq(400)
        expect_json(error: regex("render_type should be one of:"))
      end
    end

    context "when no render_type parameters" do
      it "return an error" do
        post url, client: client, token: account.access_token
        expect(response.status).to eq(500)
        expect_json(error: regex("render_type is missing"))
      end
    end

    context "when wrong routes" do
      let(:url) { "private/wrong/route" }
      it "return an error" do
        post url, client: client, render_type: "not_a_chart", token: account.access_token
        expect(response.status).to eq(404)
        expect_json(error: regex("not found with:"))
      end
    end

    context "when valid endpoint" do
      let(:res) do
        {
          data: {
            rows: [
              ["manufacturer1", true, 1, "college1", nil, 2014_01_01, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer2", true, 14, "college1", nil, 2014_02_02, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer3", false, 0, "college1", nil, nil, 2014_01_01, 1.0, 2.0, "supplier"],
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
      context "valid account" do
        it "returns 'csv json' format" do
          post url, client: client, render_type: "csv", token: account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end

      context "valid account api disable" do
        let!(:private_endpoint) { FactoryGirl.create(:hdr_endpoint, :api_disable, hdr_account: account) }
        it "returns 404 not found" do
          post url, client: client, render_type: "csv", token: account.access_token
          expect(response.status).to eq(404)
        end
      end

      context "superadmin account" do
        let!(:superadmin_account) { FactoryGirl.create(:hdr_account, :superadmin) }
        it "returns 'csv json' format" do
          post url, client: client, render_type: "csv", token: superadmin_account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end

      context "superadmin account api disable" do
        let!(:superadmin_account) { FactoryGirl.create(:hdr_account, :superadmin) }
        let!(:private_endpoint) { FactoryGirl.create(:hdr_endpoint, :api_disable, hdr_account: account) }
        it "returns 'csv json' format" do
          post url, client: client, render_type: "csv", token: superadmin_account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end

      context "invalid account" do
        let!(:other_account) { FactoryGirl.create(:hdr_account) }
        it "returns unauthorized" do
          post url, client: client, render_type: "csv", token: other_account.access_token
          expect(response.status).to eq(401)
          expect_json(error: regex("Unauthorized"))
        end
      end
    end
  end

  describe "POST public endpoint" do
    let(:url) { "public/#{public_endpoint.module_name}/#{public_endpoint.method_name}" }

    it_behaves_like "error in client parameters"

    context "when wrong render_type parameters" do
      it "return an error" do
        post url, client: client, render_type: "not_a_chart", token: account.access_token
        expect(response.status).to eq(400)
        expect_json(error: regex("render_type should be one of:"))
      end
    end

    context "when no render_type parameters" do
      it "return an error" do
        post url, client: client, token: account.access_token
        expect(response.status).to eq(500)
        expect_json(error: regex("render_type is missing"))
      end
    end

    context "when wrong routes" do
      let(:url) { "public/wrong/route" }
      it "return an error" do
        post url, client: client, render_type: "not_a_chart", token: account.access_token
        expect(response.status).to eq(404)
        expect_json(error: regex("not found with:"))
      end
    end

    context "when valid endpoint" do
      let(:res) do
        {
          data: {
            rows: [
              ["manufacturer1", true, 1, "college1", nil, 2014_01_01, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer2", true, 14, "college1", nil, 2014_02_02, 2014_01_01, 1.0, 2.0, "supplier"],
              ["manufacturer3", false, 0, "college1", nil, nil, 2014_01_01, 1.0, 2.0, "supplier"],
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
      context "valid account" do
        it "returns 'csv json' format" do
          post url, client: account.name, render_type: "csv", token: account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end

      context "superadmin account" do
        let!(:superadmin_account) { FactoryGirl.create(:hdr_account, :superadmin) }
        it "returns 'csv json' format" do
          post url, client: account.name, render_type: "csv", token: superadmin_account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end

      context "other valid account" do
        let!(:other_account) { FactoryGirl.create(:hdr_account) }
        it "returns 'csv json' format" do
          post url, client: other_account.name, render_type: "csv", token: other_account.access_token
          expect(response.status).to eq(201)
          expect_json(res)
        end
      end
    end
  end
end

require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:hdr_query_object_test) { FactoryGirl.create(:hdr_query_object, :csv) }
  let!(:account) { FactoryGirl.create(:hdr_account, :superadmin) }
  describe "GET hdr_query_objects" do
    let(:url) { "admin/hdr_query_objects?token=#{account.access_token}" }

    before(:all) do
      4.times { FactoryGirl.create(:hdr_query_object, :csv) }
    end

    context "when read all hdr_query_objects" do
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrQueryObject.count)
      end
    end

    context "when filter all hdr_query_object" do
      let(:url) { "admin/hdr_query_objects?token=#{account.access_token}&filters[name]=#{hdr_query_object_test.name}" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(1)
      end
    end

    context "when order all hdr_query_object" do
      let(:url) { "admin/hdr_query_objects?token=#{account.access_token}&order[name]=DESC" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrQueryObject.count)
      end
    end
  end

  describe "GET hdr_query_object" do
    context "when read existing hdr_query_object" do
      let(:url) { "admin/hdr_query_object/#{hdr_query_object_test.id}?token=#{account.access_token}" }
      let(:res) do
        hdr_query_object_test.attributes
          .except!("created_at", "updated_at", "hdr_query_engine_id")
          .symbolize_keys!
      end
      it "return object" do
        get url
        expect(response.status).to eq(200)
        expect_json(res)
      end
    end

    context "when read unexisting hdr_query_object" do
      let(:url) { "admin/hdr_query_object/0?token=#{account.access_token}" }

      it "return an error" do
        get url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryObject"))
      end
    end
  end

  describe "POST hdr_query_object" do
    let(:url) { "admin/hdr_query_object" }

    context "when create valid hdr_query_object" do
      let(:new_hdr_query_object) { attributes_for(:hdr_query_object, :csv) }

      it "return object" do
        post url, hdr_query_object: new_hdr_query_object, token: account.access_token
        expect(response.status).to eq(201)
        expect_json(new_hdr_query_object)
      end

      describe "hdr_query_object create" do
        subject { -> { post url, hdr_query_object: new_hdr_query_object, token: account.access_token } }
        it { should change(HdrQueryObject, :count).by(1) }
      end
    end

    context "when create valid hdr_query_object with nested attributes" do
      let(:new_hdr_query_object) do
        attributes_for(:hdr_query_object, :csv, hdr_query_engine_id: HdrQueryEngine.first.id,
                                                hdr_export_type_ids: [HdrExportType.first.id, HdrExportType.last.id])
      end

      it "return OK" do
        post url, hdr_query_object: new_hdr_query_object, token: account.access_token
        expect(response.status).to eq(201)
      end

      describe "hdr_query_object creation" do
        subject { -> { post url, hdr_query_object: new_hdr_query_object, token: account.access_token } }
        it { should change(HdrQueryObject, :count).by(1) }
        it { should change(HdrQueryObjectsExportType, :count).by(2) }
      end
    end
  end

  describe "PUT hdr_query_object" do
    let(:update_hdr_query_object) { attributes_for(:hdr_query_object) }

    context "when update existing hdr_query_object" do
      let(:url) { "admin/hdr_query_object/#{hdr_query_object_test.id}" }

      it "return object" do
        put url, hdr_query_object: update_hdr_query_object, token: account.access_token
        expect(response.status).to eq(200)
        expect_json(update_hdr_query_object)
      end
    end

    context "when update unexisting hdr_query_object" do
      let(:url) { "admin/hdr_query_object/0" }

      it "return an error" do
        put url, hdr_query_object: update_hdr_query_object, token: account.access_token
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryObject"))
      end
    end
  end

  describe "DELETE hdr_query_object" do
    context "when delete hdr_query_object" do
      let(:url) { "admin/hdr_query_object/#{hdr_query_object_test.id}?token=#{account.access_token}" }

      it "return object" do
        delete url
        expect(response.status).to eq(200)
        expect { HdrQueryObject.find(hdr_query_object_test.id) }.to raise_exception
      end

      describe "hdr_query_object delete" do
        subject { -> { delete url } }
        it { should change(HdrQueryObject, :count).by(-1) }
        it { should change(HdrQueryObjectsExportType, :count).by(-1) }
      end
    end

    context "when delete unexisting hdr_query_object" do
      let(:url) { "admin/hdr_query_object/0?token=#{account.access_token}" }

      it "return an error" do
        delete url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryObject"))
      end
    end
  end
end

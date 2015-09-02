require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:hdr_export_type_test) { FactoryGirl.create(:hdr_export_type, :csv) }
  describe "GET hdr_export_types" do
    let(:url) { "admin/hdr_export_types" }

    before(:all) do
      4.times { FactoryGirl.create(:hdr_export_type, :csv) }
    end

    context "when read all hdr_export_type" do
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrExportType.count)
      end
    end

    context "when filter all hdr_export_types" do
      let(:url) { "admin/hdr_export_types?filters[name]=#{hdr_export_type_test.name}" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(1)
      end
    end

    context "when order all hdr_export_type" do
      let(:url) { "admin/hdr_export_types?order[name]=DESC" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrExportType.count)
      end
    end
  end

  describe "GET hdr_export_type" do
    context "when read existing hdr_export_type" do
      let(:url) { "admin/hdr_export_type/#{hdr_export_type_test.id}" }
      let(:res) do
        hdr_export_type_test.attributes
          .except!("created_at", "updated_at")
          .symbolize_keys!
      end
      it "return object" do
        get url
        expect(response.status).to eq(200)
        expect_json(res)
      end
    end

    context "when read unexisting hdr_export_type" do
      let(:url) { "admin/hdr_export_type/0" }

      it "return an error" do
        get url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrExportType"))
      end
    end
  end

  describe "POST hdr_export_type" do
    let(:url) { "admin/hdr_export_type" }

    context "when create valid hdr_export_type" do
      let(:new_hdr_export_type) { attributes_for(:hdr_export_type) }

      it "return object" do
        post url, hdr_export_type: new_hdr_export_type
        expect(response.status).to eq(201)
        expect_json(new_hdr_export_type)
      end

      describe "hdr_export_type create" do
        subject { -> { post url, hdr_export_type: new_hdr_export_type } }
        it { should change(HdrExportType, :count).by(1) }
      end
    end

    context "when create already existing hdr_export_type" do
      let(:invalid_new_hdr_export_type) { hdr_export_type_test.attributes.except!("id", "created_at", "updated_at") }

      it "return an error" do
        post url, hdr_export_type: invalid_new_hdr_export_type
        expect(response.status).to eq(409)
        expect_json(error: regex("Validation failed"))
      end
    end
  end

  describe "PUT hdr_export_type" do
    let(:update_hdr_export_type) { attributes_for(:hdr_export_type) }

    context "when update existing hdr_export_type" do
      let(:url) { "admin/hdr_export_type/#{hdr_export_type_test.id}" }

      it "return object" do
        put url, hdr_export_type: update_hdr_export_type
        expect(response.status).to eq(200)
        expect_json(update_hdr_export_type)
      end
    end

    context "when update unexisting hdr_export_type" do
      let(:url) { "admin/hdr_export_type/0" }

      it "return an error" do
        put url, hdr_export_type: update_hdr_export_type
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrExportType"))
      end
    end
  end

  describe "DELETE hdr_export_type" do
    context "when delete hdr_export_type" do
      let(:url) { "admin/hdr_export_type/#{hdr_export_type_test.id}" }

      it "return object" do
        delete url
        expect(response.status).to eq(200)
        expect { HdrExportType.find(hdr_export_type_test.id) }.to raise_exception
      end

      describe "hdr_export_type delete" do
        subject { -> { delete url } }
        it { should change(HdrExportType, :count).by(-1) }
      end
    end

    context "when delete unexisting hdr_export_type" do
      let(:url) { "admin/hdr_export_type/0" }

      it "return an error" do
        delete url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrExportType"))
      end
    end
  end
end

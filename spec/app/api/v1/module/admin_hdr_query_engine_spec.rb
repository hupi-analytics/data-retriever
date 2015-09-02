require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:hdr_query_engine_test) { FactoryGirl.create(:hdr_query_engine, :impala) }
  describe "GET hdr_query_engines" do
    let(:url) { "admin/hdr_query_engines" }

    before(:all) do
      4.times { FactoryGirl.create(:hdr_query_engine, :impala) }
    end

    context "when read all hdr_query_engine" do
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrQueryEngine.count)
      end
    end

    context "when filter all hdr_query_engine" do
      let(:url) { "admin/hdr_query_engines?filters[name]=#{hdr_query_engine_test.name}" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(1)
      end
    end

    context "when order all hdr_query_engine" do
      let(:url) { "admin/hdr_query_engines?order[name]=DESC" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrQueryEngine.count)
      end
    end
  end

  describe "GET hdr_query_engine" do
    context "when read existing hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/#{hdr_query_engine_test.id}" }
      let(:res) do
        hdr_query_engine_test.attributes
          .except!("created_at", "updated_at", "settings")
          .symbolize_keys!
      end
      it "return object" do
        get url
        expect(response.status).to eq(200)
        expect_json(res)
      end
    end

    context "when read unexisting hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/0" }

      it "return an error" do
        get url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryEngine"))
      end
    end
  end

  describe "POST hdr_query_engine" do
    let(:url) { "admin/hdr_query_engine" }

    context "when create valid hdr_query_engine" do
      let(:new_hdr_query_engine) { attributes_for(:hdr_query_engine, :impala) }

      it "return object" do
        post url, hdr_query_engine: new_hdr_query_engine
        expect(response.status).to eq(201)
        expect_json(new_hdr_query_engine.reject { |k, _|  k == :settings })
      end

      describe "hdr_query_engine create" do
        subject { -> { post url, hdr_query_engine: new_hdr_query_engine } }
        it { should change(HdrQueryEngine, :count).by(1) }
      end
    end

    context "when create already existing hdr_query_engine" do
      let(:invalid_new_hdr_query_engine) { hdr_query_engine_test.attributes.except!("id", "created_at", "updated_at") }

      it "return an error" do
        post url, hdr_query_engine: invalid_new_hdr_query_engine
        expect(response.status).to eq(409)
        expect_json(error: regex("Validation failed"))
      end
    end
  end

  describe "PUT hdr_query_engine" do
    let(:update_hdr_query_engine) { attributes_for(:hdr_query_engine, :impala) }

    context "when update existing hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/#{hdr_query_engine_test.id}" }

      it "return object" do
        put url, hdr_query_engine: update_hdr_query_engine
        expect(response.status).to eq(200)
        expect_json(update_hdr_query_engine.reject { |k, _| k == :settings })
      end
    end

    context "when update unexisting hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/0" }

      it "return an error" do
        put url, hdr_query_engine: update_hdr_query_engine
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryEngine"))
      end
    end
  end

  describe "DELETE hdr_query_engine" do
    context "when delete hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/#{hdr_query_engine_test.id}" }

      it "return object" do
        delete url
        expect(response.status).to eq(200)
        expect { HdrQueryEngine.find(hdr_query_engine_test.id) }.to raise_exception
      end

      describe "hdr_query_engine delete" do
        subject { -> { delete url } }
        it { should change(HdrQueryEngine, :count).by(-1) }
      end
    end

    context "when delete unexisting hdr_query_engine" do
      let(:url) { "admin/hdr_query_engine/0" }

      it "return an error" do
        delete url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrQueryEngine"))
      end
    end
  end
end

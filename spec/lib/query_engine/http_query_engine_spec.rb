require "spec_helper"

describe HttpQueryEngine do
  let(:qe) { HttpQueryEngine.new("test_client", { "http_host" => "localhost", "http_port" => "9000"}) }
  let(:summary) do
    <<-SUMMARY
    {
      "probability": "999"
    }
    SUMMARY
  end

  context "decorate" do
    let(:query) do
    end
    let(:query_params) do
      { input_text: "je suis content" }
    end
    let(:query_res) do
      { predict: query_params }
    end

    it { expect(qe.decorate(query, nil, query_params)).to include(query_res) }
  end

  context "explain" do
    let(:query) do
      { predict: { input_text: "je suis content" } }
    end
    let(:info) do
      { module_name: "module1", method_name: "method1", query_object_name: "qo1", updated_at: Time.new(2015, 03, 17, 12, 41, 36) }
    end

    it "should return prediction" do
      WebMock.stub_request(:post, "http://localhost:9000/predict").to_return(body: summary, status: 200)
      qe.connect
      expect(qe.explain(query, info)).to eq(JSON.parse(summary))
    end
  end

end

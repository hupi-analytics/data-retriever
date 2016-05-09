require "spec_helper"

describe OpenscoringQueryEngine do
  let(:qe) { OpenscoringQueryEngine.new("test_client", { "host" => "localhost", "port" => "3242"}) }
  let(:summary) do
    <<-SUMMARY
      {
          "id" : "module1_method1_qo1",
          "miningFunction" : "classification",
          "summary" : "Tree model",
          "properties" : {
              "created.timestamp" : "2015-03-17T12:41:35.933+0000",
              "accessed.timestamp" : "2015-03-21T09:35:58.582+0000",
              "file.size" : 4918,
              "file.md5sum" : "870e1a7931d39f919fe3c02556bf6241"
          },
          "schema" : {
              "activeFields" : [
                  {
                      "id" : "Sepal_Length",
                      "name" : "Sepal length in cm",
                      "dataType" : "double",
                      "opType" : "continuous",
                      "values" : [ "[4.3, 7.9]" ]
                  },
                  {
                      "id" : "Sepal_Width",
                      "name" : "Sepal width in cm",
                      "dataType" : "double",
                      "opType" : "continuous",
                      "values" : [ "[2.0, 4.4]" ]
                  },
                  {
                      "id" : "Petal_Length",
                      "name" : "Petal length in cm",
                      "dataType" : "double",
                      "opType" : "continuous",
                      "values" : [ "[1.0, 6.9]" ]
                  },
                  {
                      "id" : "Petal_Width",
                      "name" : "Petal width in cm",
                      "dataType" : "double",
                      "opType" : "continuous",
                      "values" : [ "[0.1, 2.5]" ]
                  }
              ],
              "groupFields" : [],
              "targetFields" : [
                  {
                      "id" : "Species",
                      "dataType" : "string",
                      "opType" : "categorical",
                      "values" : [ "setosa", "versicolor", "virginica" ]
                  }
              ],
              "outputFields" : [
                  {
                      "id" : "Probability_setosa",
                      "dataType" : "double",
                      "opType" : "continuous"
                  },
                  {
                      "id" : "Probability_versicolor",
                      "dataType" : "double",
                      "opType" : "continuous"
                  },
                  {
                      "id" : "Probability_virginica",
                      "dataType" : "double",
                      "opType" : "continuous"
                  },
                  {
                      "id" : "Node_Id",
                      "dataType" : "string",
                      "opType" : "categorical"
                  }
              ]
          }
      }
    SUMMARY
  end

  context "decorate" do
    let(:query) do
      <<-PMML
        <pmml></pmml>
      PMML
    end
    let(:query_params) do
      { feature1: 12, feature2: "black" }
    end
    let(:query_res) do
      { pmml: query, predict: { id: match(/\w*/), arguments: query_params } }
    end

    it { expect(qe.decorate(query, nil, query_params)).to include(query_res) }
  end

  context "explain" do
    let(:query) do
      { pmml: "<pmml></pmml>", predict: { id: "c867e9e46ea026c1eb84161f734b4349", arguments: { feature1: 12, feature2: "black" } } }
    end
    let(:info) do
      { module_name: "module1", method_name: "method1", query_object_name: "qo1", updated_at: Time.new(2015, 03, 17, 12, 41, 36) }
    end

    it "return openscoring summary" do
      WebMock.stub_request(:get, "http://localhost:3242/openscoring/model/module1_method1_qo1").to_return(body: summary, status: 200)
      qe.connect
      expect(qe.explain(query, info)).to eq(JSON.parse(summary))
    end
  end

  context "check_model" do
    let(:pmml) do
      <<-PMML
        <pmml></pmml>
      PMML
    end

    let(:model_name) { "module1_method1_qo1" }

    context "with unregister openscoring model" do
      it "upsert model" do
        WebMock.stub_request(:get, "http://localhost:3242/openscoring/model/#{model_name}").to_return(status: 404)
        upsert_model = WebMock.stub_request(:put, "http://localhost:3242/openscoring/model/#{model_name}").to_return(status: 201)
        qe.connect
        expect(qe.send(:check_model, pmml, model_name, Time.new(2015, 03, 17, 12, 41, 36))).to eq(true)
        expect(upsert_model).to have_been_requested
      end
    end

    context "with outdated openscoring model" do
      it "return true" do
        WebMock.stub_request(:get, "http://localhost:3242/openscoring/model/module1_method1_qo1").to_return(status: 200, body: summary)
        upsert_model = WebMock.stub_request(:put, "http://localhost:3242/openscoring/model/module1_method1_qo1").to_return(status: 200)
        qe.connect
        expect(qe.send(:check_model, pmml, model_name, Time.new(2016, 01, 01))).to eq(true)
        expect(upsert_model).to have_been_requested
      end
    end

    context "with outdated openscoring model, failed upsert" do
      it "raise an error" do
        WebMock.stub_request(:get, "http://localhost:3242/openscoring/model/module1_method1_qo1").to_return(status: 200, body: summary)
        upsert_model = WebMock.stub_request(:put, "http://localhost:3242/openscoring/model/module1_method1_qo1").to_return(status: 400)
        qe.connect
        expect { qe.send(:check_model, pmml, model_name, Time.new(2016, 01, 01)) }.to raise_error(Net::HTTPServerException)
        expect(upsert_model).to have_been_requested
      end
    end
  end
end

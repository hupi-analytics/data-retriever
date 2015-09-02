# -*- encoding : utf-8 -*-
shared_examples "error in client parameters" do
  let(:res) { { error: "no client set" } }

  context "When empty client parameters" do
    it "returns error" do
      post url, client: ""
      expect(response.status).to eq(400)
      expect_json(res)
    end
  end

  context "When missing client parameters" do
    it "returns error" do
      post url
      expect(response.status).to eq(400)
      expect_json(res)
    end
  end
end

shared_examples "error in render_type parameters" do
  let(:params_error) { { error: regex("render_type does not have a valid value") } }

  context "When wrong render_type parameters" do
    it "returns error" do
      post url, client: client, render_type: "not_a_chart"
      expect(response.status).to eq(400)
      expect_json(params_error)
    end
  end

  context "When no render_type parameters" do
    it "returns error" do
      post url, client: client
      expect(response.status).to eq(400)
      expect_json(params_error)
    end
  end
end

shared_examples "error when missing parameters" do
  it "returns an error" do
    post url, client: client, render_type: "csv"
    expect_json(params_error)
  end
end

shared_examples "start date or end date is missing" do
  context "When start_date is missing" do
    let(:params) { { client: client, render_type: "csv", filters: { end_date: "20140101" } } }
    let(:params_error) { { error: regex("start_date, end_date provide all or none of parameters") } }
    it "returns error" do

      post url, params
      expect(response.status).to eq(400)
      expect_json(params_error)
    end
  end

  context "When end_date is missing" do
    let(:params) { { client: client, render_type: "csv", filters: { start_date: "20140101" } } }
    let(:params_error) { { error: regex("start_date, end_date provide all or none of parameters") } }
    it "returns error" do
      post url, params
      expect(response.status).to eq(400)
      expect_json(params_error)
    end
  end
end

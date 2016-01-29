# -*- encoding : utf-8 -*-
shared_examples "error in client parameters" do
  context "When empty client parameters" do
    it "returns error" do
      post url, client: "", token: account.access_token, render_type: ""
      expect(response.status).to eq(400)
      expect_json(error: "no client set")
    end
  end

  context "When missing client parameters" do
    it "returns error" do
      post url, token: account.access_token, render_type: ""
      expect(response.status).to eq(400)
      expect_json(error: "client is missing")
    end
  end
end

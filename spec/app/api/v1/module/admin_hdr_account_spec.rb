require "spec_helper"

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let!(:superadmin_account) { FactoryGirl.create(:hdr_account, :superadmin) }
  describe "GET hdr_accounts" do
    let(:url) { "admin/hdr_accounts?token=#{superadmin_account.access_token}" }

    before(:all) do
      4.times { FactoryGirl.create(:hdr_account) }
    end

    context "when read all hdr_account" do
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrAccount.count)
      end
    end

    context "when filter all hdr_account" do
      let(:url) { "admin/hdr_accounts?token=#{superadmin_account.access_token}&filters[name]=#{superadmin_account.name}" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(1)
      end
    end

    context "when order all hdr_account" do
      let(:url) { "admin/hdr_accounts?token=#{superadmin_account.access_token}&order[name]=DESC" }
      it "return list of object" do
        get url
        expect_json_types(:array)
        expect_json_sizes(HdrAccount.count)
      end
    end
  end

  describe "GET hdr_account" do
    context "when read existing hdr_account" do
      let(:url) { "admin/hdr_account/#{superadmin_account.id}?token=#{superadmin_account.access_token}" }
      let(:res) do
        superadmin_account.attributes
          .except!("created_at", "updated_at", "role", "name", "access_token")
          .symbolize_keys!
      end
      it "return object" do
        get url
        expect(response.status).to eq(200)
        expect_json(res)
      end
    end

    context "when read unexisting hdr_account" do
      let(:url) { "admin/hdr_account/0?token=#{superadmin_account.access_token}" }

      it "return an error" do
        get url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrAccount"))
      end
    end
  end

  describe "POST hdr_account" do
    let(:url) { "admin/hdr_account" }

    context "when create valid hdr_account" do
      let(:new_hdr_account) { attributes_for(:hdr_account) }

      it "return object" do
        post url, hdr_account: new_hdr_account, token: superadmin_account.access_token
        expect(response.status).to eq(201)
        expect_json(new_hdr_account)
      end

      describe "hdr_account create" do
        subject { -> { post url, hdr_account: new_hdr_account, token: superadmin_account.access_token } }
        it { should change(HdrAccount, :count).by(1) }
      end
    end
  end

  describe "PUT hdr_account" do
    let(:update_hdr_account) { attributes_for(:hdr_account) }

    context "when update existing hdr_account" do
      let(:url) { "admin/hdr_account/#{superadmin_account.id}" }

      it "return object" do
        put url, hdr_account: update_hdr_account, token: superadmin_account.access_token
        expect(response.status).to eq(200)
        expect_json(update_hdr_account)
      end
    end

    context "when update unexisting hdr_account" do
      let(:url) { "admin/hdr_account/0" }

      it "return an error" do
        put url, hdr_account: update_hdr_account, token: superadmin_account.access_token
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrAccount"))
      end
    end
  end

  describe "DELETE hdr_account" do
    context "when delete hdr_account" do
      let(:url) { "admin/hdr_account/#{superadmin_account.id}?token=#{superadmin_account.access_token}" }

      it "return object" do
        delete url
        expect(response.status).to eq(200)
        expect { HdrAccount.find(superadmin_account.id) }.to raise_exception
      end

      describe "hdr_account delete" do
        subject { -> { delete url } }
        it { should change(HdrAccount, :count).by(-1) }
      end
    end

    context "when delete unexisting hdr_account" do
      let(:url) { "admin/hdr_account/0?token=#{superadmin_account.access_token}" }

      it "return an error" do
        delete url
        expect(response.status).to eq(404)
        expect_json(error: regex("Couldn't find HdrAccount"))
      end
    end
  end

  describe "GET refresh_token" do
    let(:url) { "admin/hdr_account/#{superadmin_account.id}/refresh_token?token=#{superadmin_account.access_token}" }
    it "return a token" do
      get url
      superadmin_account.reload
      expect_json(access_token: superadmin_account.access_token)
    end

    it "change the token" do
      expect {
        get url
        superadmin_account.reload
      }.to change(superadmin_account, :access_token)
    end
  end
end

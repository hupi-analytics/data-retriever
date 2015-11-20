require 'spec_helper'

describe DataRetriever::API do
  def app
    DataRetriever::API
  end

  let(:client) { "test" }

  describe "POST estimate/vehicle" do
    let(:url) { "estimate/vehicle" }

    context "when valid params" do
      let(:valid_param) do
        {
          client: client,
          vehicle: {
            heater: 1,
            seets: 4,
            doors: 2,
            '2' => 1
          }
        }
      end
      let(:res) do
        {
          estimate: 8, upper_bound: 10, lower_bound: 6
        }
      end

      it "return price with bound" do
        post url, valid_param
        expect_json(res)
      end
    end

    context "when invalid params" do
      let(:invalid_param) do
        {
          client: client,
          vehicle: {
            heater: 1,
            seets: 4,
            doors: 2,
            truc: 14
          }
        }
      end

      it "return price with bound" do
        post url, invalid_param
        expect(response.status).to eq(400)
        expect_json(error: regex("vehicle settings not found:"))
      end
    end

    context "when missing subject" do
      let(:invalid_param) do
        {
          client: client,
        }
      end

      it "return price with bound" do
        post url, invalid_param
        expect(response.status).to eq(400)
        expect_json(error: regex("vehicle is missing"))
      end
    end
  end
end

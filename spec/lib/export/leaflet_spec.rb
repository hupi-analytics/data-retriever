# -*- encoding : utf-8 -*-
require "spec_helper"

describe Export do
  describe "when leaflet" do
    let(:cursor) do
      [
        { "collection" => "features", "layer_name" => "calque", "type" => "Feature", "geometry_type" => "Point", "lat" => 10.00, "lng" => 0.0, "data1" => "ab", "data2" => "bc" },
        { "collection" => "features", "layer_name" => "calque", "type" => "Feature", "geometry_type" => "Point", "lat" => 20.00, "lng" => 1.0, "data1" => "ac", "data2" => "bd" },
        { "collection" => "features", "layer_name" => "calque", "type" => "Feature", "geometry_type" => "Point", "lat" => 30.00, "lng" => 2.0, "data1" => "ad", "data2" => "be" }
      ]
    end
    let(:leaflet) do
      {
        "calque" => {
          type: "FeatureCollection",
          features: [
            { type: "Feature", geometry: { type: "Point", coordinates: [0.0, 10.0] }, properties: { "data1" => "ab", "data2" => "bc" } },
            { type: "Feature", geometry: { type: "Point", coordinates: [1.0, 20.0] }, properties: { "data1" => "ac", "data2" => "bd" } },
            { type: "Feature", geometry: { type: "Point", coordinates: [2.0, 30.0] }, properties: { "data1" => "ad", "data2" => "be" } }
          ]
        }
      }
    end

    it "return leaflet format" do
      expect(Export.leaflet(cursor)).to eq(leaflet)
    end
  end
end

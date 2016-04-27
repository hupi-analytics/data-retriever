# -*- encoding : utf-8 -*-
require "spec_helper"

describe Export do
  describe "when csv" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10, "datestamp" => 2014_10_01 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9, "datestamp" => 2014_10_02 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:csv) do
      {
        rows: [
          ["cat1", "ser1", 10, 2014_10_01],
          ["cat1", "ser2", 9, 2014_10_02],
          ["cat1", "ser3", 6, 2014_10_03],
          ["cat2", "ser1", 8, 2014_10_04],
          ["cat2", "ser2", 7, 2014_10_05]
        ],
        header: %w(category serie value datestamp)
      }
    end

    it "returns csv format" do
      expect(Export.csv(cursor)).to eq(csv)
    end
  end

  describe "when csv with partial cursor" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:csv) do
      {
        rows: [
          ["cat1", "ser1", 10],
          ["cat1", "ser2", 9],
          ["cat1", "ser3", 6, 2014_10_03],
          ["cat2", "ser1", 8, 2014_10_04],
          ["cat2", "ser2", 7, 2014_10_05]
        ],
        header: %w(category serie value datestamp)
      }
    end

    it "returns csv format" do
      expect(Export.csv(cursor)).to eq(csv)
    end
  end

  describe "when csv with header given" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:csv) do
      {
        rows: [
          [nil, 10, "cat1"],
          [nil, 9, "cat1"],
          [2014_10_03, 6, "cat1"],
          [2014_10_04, 8, "cat2"],
          [2014_10_05, 7, "cat2"]
        ],
        header: %w(datestamp value category)
      }
    end
    let(:opts) { { "header" => "datestamp value category" } }

    it "returns csv format" do
      expect(Export.csv(cursor, opts)).to eq(csv)
    end
  end

  describe "when csv with header given and format" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:csv) do
      {
        rows: [
          [nil, 10, "cat1"],
          [nil, 9, "cat1"],
          ["2014-10-03", 6, "cat1"],
          ["2014-10-04", 8, "cat2"],
          ["2014-10-05", 7, "cat2"]
        ],
        header: %w(datestamp value category)
      }
    end
    let(:opts) do
      {
        "header" => "datestamp value category",
        "format" => "{
          \"datestamp\": [
            { \"action\": \"to_string\" },
            { \"action\": \"date_string_format\", \"params\": { \"input_format\": \"%Y%m%d\", \"output_format\": \"%Y-%m-%d\" } }
          ]
        }"
      }
    end

    it "returns csv format" do
      expect(Export.csv(cursor, opts)).to eq(csv)
    end
  end

  describe "when cursor and format" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:cursor_res) do
      [
        { "category" => "cat1", "value" => 10 },
        { "category" => "cat1", "value" => 9 },
        { "category" => "cat1", "value" => 6, "datestamp" => "2014-10-03" },
        { "category" => "cat2", "value" => 8, "datestamp" => "2014-10-04" },
        { "category" => "cat2", "value" => 7, "datestamp" => "2014-10-05" }
      ]
    end
    let(:opts) do
      {
        "header" => "datestamp value category",
        "format" => "{
          \"datestamp\": [
            { \"action\": \"to_string\" },
            { \"action\": \"date_string_format\", \"params\": { \"input_format\": \"%Y%m%d\", \"output_format\": \"%Y-%m-%d\" } }
          ]
        }"
      }
    end

    it "returns cursor format" do
      expect(Export.cursor(cursor, opts)).to eq(cursor_res)
    end
  end

  describe "when multiple csv" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10, "datestamp" => 2014_10_01 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9, "datestamp" => 2014_10_02 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:multiple_csv) do
      {
        header: %w(serie value datestamp),
        rows: {
          "cat1" => [
            ["ser1", 10, 2014_10_01],
            ["ser2",  9, 2014_10_02],
            ["ser3",  6, 2014_10_03]
          ],
          "cat2" => [
            ["ser1",  8, 2014_10_04],
            ["ser2",  7, 2014_10_05]
          ]
        }
      }
    end

    it "returns multiple_csv format" do
      expect(Export.multiple_csv(cursor)).to eq(multiple_csv)
    end
  end

  describe "when multiple csv with header given" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10, "datestamp" => 2014_10_01 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9, "datestamp" => 2014_10_02 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:multiple_csv) do
      {
        header: %w(datestamp value serie),
        rows: {
          "cat1" => [
            [2014_10_01, 10, "ser1"],
            [2014_10_02,  9, "ser2"],
            [2014_10_03,  6, "ser3"]
          ],
          "cat2" => [
            [2014_10_04,  8, "ser1"],
            [2014_10_05,  7, "ser2"]
          ]
        }
      }
    end
    let(:opts) { { "header" => "datestamp value serie" } }

    it "returns multiple_csv format" do
      expect(Export.multiple_csv(cursor, opts)).to eq(multiple_csv)
    end
  end

  describe "when json_value" do
    describe "1 level" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1" },
          { "category" => "cat1", "serie" => "ser1" },
          { "category" => "cat1", "serie" => "ser2" },
          { "category" => "cat1", "serie" => "ser3" },
          { "category" => "cat2", "serie" => "ser1" },
          { "category" => "cat2", "serie" => "ser2" },
          { "category" => "cat2", "serie" => "ser2" }
        ]
      end
      let(:json_value) { { "cat1" => "ser3", "cat2" => "ser2" } }

      it "returns json_value format" do
        expect(Export.json_value(cursor)).to eq(json_value)
      end
    end

    describe "2 level" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1", "value" => 10 },
          { "category" => "cat1", "serie" => "ser1", "value" => 4 },
          { "category" => "cat1", "serie" => "ser2", "value" => 9 },
          { "category" => "cat1", "serie" => "ser3", "value" => 6 },
          { "category" => "cat2", "serie" => "ser1", "value" => 8 },
          { "category" => "cat2", "serie" => "ser2", "value" => 7 },
          { "category" => "cat2", "serie" => "ser2", "value" => 5 }
        ]
      end
      let(:json_value) do
        {
          "cat1" => {
            "ser1" => 4,
            "ser2" => 9,
            "ser3" => 6
          },
          "cat2" => {
            "ser1" => 8,
            "ser2" => 5
          }
        }
      end

      it "returns json_value format" do
        expect(Export.json_value(cursor)).to eq(json_value)
      end
    end

    describe "3 level" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1", "ser" => "s", "value" => 10 },
          { "category" => "cat1", "serie" => "ser1", "ser" => "s", "value" => 4 },
          { "category" => "cat1", "serie" => "ser2", "ser" => "s", "value" => 9 },
          { "category" => "cat1", "serie" => "ser3", "ser" => "s", "value" => 6 },
          { "category" => "cat2", "serie" => "ser1", "ser" => "s", "value" => 8 },
          { "category" => "cat2", "serie" => "ser2", "ser" => "s1", "value" => 7 },
          { "category" => "cat2", "serie" => "ser2", "ser" => "s2", "value" => 5 }
        ]
      end
      let(:json_value) do
        {
          "cat1" => {
            "ser1" => { "s" => 4 },
            "ser2" => { "s" => 9 },
            "ser3" => { "s" => 6 }
          },
          "cat2" => {
            "ser1" => { "s" => 8 },
            "ser2" => { "s1" => 7, "s2" => 5 }
          }
        }
      end

      it "returns json_value format" do
        expect(Export.json_value(cursor)).to eq(json_value)
      end
    end
  end

  describe "when to json_array" do
    describe "1 level" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1" },
          { "category" => "cat1", "serie" => "ser1"},
          { "category" => "cat1", "serie" => "ser2" },
          { "category" => "cat1", "serie" => "ser3"},
          { "category" => "cat2", "serie" => "ser1"},
          { "category" => "cat2", "serie" => "ser2"},
          { "category" => "cat2", "serie" => "ser2"}
        ]
      end
      let(:json_array) do
        {
          "cat1" => %w(ser1 ser1 ser2 ser3),
          "cat2" => %w(ser1 ser2 ser2)
        }
      end

      it "returns json_array format" do
        expect(Export.json_array(cursor)).to eq(json_array)
      end
    end

    describe "2 levels" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1", "value" => 10 },
          { "category" => "cat1", "serie" => "ser1", "value" => 4 },
          { "category" => "cat1", "serie" => "ser2", "value" => 9 },
          { "category" => "cat1", "serie" => "ser3", "value" => 6 },
          { "category" => "cat2", "serie" => "ser1", "value" => 8 },
          { "category" => "cat2", "serie" => "ser2", "value" => 7 },
          { "category" => "cat2", "serie" => "ser2", "value" => 5 }
        ]
      end
      let(:json_array) do
        {
          "cat1" => {
            "ser1" => [10, 4],
            "ser2" => [9],
            "ser3" => [6]
          },
          "cat2" => {
            "ser1" => [8],
            "ser2" => [7, 5]
          }
        }
      end

      it "returns json_array format" do
        expect(Export.json_array(cursor)).to eq(json_array)
      end
    end

    describe "3 levels" do
      let(:cursor) do
        [
          { "category" => "cat1", "serie" => "ser1", "ser" => "s", "value" => 10 },
          { "category" => "cat1", "serie" => "ser1", "ser" => "s", "value" => 4 },
          { "category" => "cat1", "serie" => "ser2", "ser" => "s", "value" => 9 },
          { "category" => "cat1", "serie" => "ser3", "ser" => "s", "value" => 6 },
          { "category" => "cat2", "serie" => "ser1", "ser" => "s", "value" => 8 },
          { "category" => "cat2", "serie" => "ser2", "ser" => "s1", "value" => 7 },
          { "category" => "cat2", "serie" => "ser2", "ser" => "s2", "value" => 5 }
        ]
      end
      let(:json_array) do
        {
          "cat1" => {
            "ser1" => { "s" => [10, 4] },
            "ser2" => { "s" => [9] },
            "ser3" => { "s" => [6] }
          },
          "cat2" => {
            "ser1" => { "s" => [8] },
            "ser2" => { "s1" => [7], "s2" => [5] }
          }
        }
      end

      it "returns json_array format" do
        expect(Export.json_array(cursor)).to eq(json_array)
      end
    end
  end

  describe "when value" do
    let(:cursor) { [{ "my_value" => 14 }, { "my_value" => 42 }] }
    let(:value) { { value: 42 } }

    it "returns value" do
      expect(Export.value(cursor)).to eq(value)
    end
  end

  describe "format round value" do
    let(:formats) do
      [{ "action" => "round", "params" => 2 }]
    end

    it "round the value" do
      expect(Export.format_value(1.0001, formats)).to eq(1)
    end
  end

  describe "format datestamp to date" do
    let(:formats) do
      [
        { "action" => "to_string" },
        { "action" => "date_string_format", "params" => { "input_format" => "%Y%m%d", "output_format" => "%Y:%m:%d" } },
        { "action" => "date_string_to_timestamp", "params" => { "input_format" => "%Y:%m:%d" } },
        { "action" => "timestamp_format", "params" => { "output_format" => "%Y-%m-%d" } }
      ]
    end

    it "convert datestamp to date string" do
      expect(Export.format_value(2014_10_01, formats)).to eq("2014-10-01")
    end
  end
end

# -*- encoding : utf-8 -*-
require "spec_helper"

describe Export do
  describe "when category_serie_value" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7 }
      ]
    end
    let(:column_stacked) do
      {
        series: [
          { name: "ser1", data: [10, 8] },
          { name: "ser2", data: [9, 7] },
          { name: "ser3", data: [6, 0] }
        ],
        categories: %w(cat1 cat2)
      }
    end

    it "returns highchart category_serie_value format" do
      expect(Export.category_serie_value(cursor)).to eq(column_stacked)
    end
  end

  describe "when column stacked grouped" do
    let(:cursor) do
      [
        { "category" => "Apples", "serie" => "John", "stack" => "male", "value" => 5 },
        { "category" => "Oranges", "serie" => "John", "stack" => "male", "value" => 3 },
        { "category" => "Pears", "serie" => "John", "stack" => "male", "value" => 4 },
        { "category" => "Grapes", "serie" => "John", "stack" => "male", "value" => 7 },
        { "category" => "Bananas", "serie" => "John", "stack" => "male", "value" => 2 },

        { "category" => "Apples", "serie" => "Joe", "stack" => "male", "value" => 3 },
        { "category" => "Oranges", "serie" => "Joe", "stack" => "male", "value" => 4 },
        { "category" => "Pears", "serie" => "Joe", "stack" => "male", "value" => 4 },
        { "category" => "Grapes", "serie" => "Joe", "stack" => "male", "value" => 2 },

        { "category" => "Apples", "serie" => "Jane", "stack" => "female", "value" => 2 },
        { "category" => "Oranges", "serie" => "Jane", "stack" => "female", "value" => 5 },
        { "category" => "Pears", "serie" => "Jane", "stack" => "female", "value" => 6 },
        { "category" => "Grapes", "serie" => "Jane", "stack" => "female", "value" => 2 },
        { "category" => "Bananas", "serie" => "Jane", "stack" => "female", "value" => 1 },

        { "category" => "Apples", "serie" => "Janet", "stack" => "female", "value" => 3 },
        { "category" => "Pears", "serie" => "Janet", "stack" => "female", "value" => 4 },
        { "category" => "Grapes", "serie" => "Janet", "stack" => "female", "value" => 4 },
        { "category" => "Bananas", "serie" => "Janet", "stack" => "female", "value" => 3 }
      ]
    end
    let(:column_stacked_grouped) do
      {
        series: [
          { name: "Jane", stack: "female", data: [2, 5, 6, 2, 1] },
          { name: "Janet", stack: "female", data: [3, 0, 4, 4, 3] },
          { name: "Joe", stack: "male", data: [3, 4, 4, 2, 0] },
          { name: "John", stack: "male", data: [5, 3, 4, 7, 2] }
        ],
        categories: %w(Apples Oranges Pears Grapes Bananas)
      }
    end

    it "returns highchart serie_value  grouped format" do
      expect(Export.column_stacked_grouped(cursor)).to eq(column_stacked_grouped)
    end
  end

  describe "when serie_value" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10, "datestamp" => 2014_10_01 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9, "datestamp" => 2014_10_02 },
        { "category" => "cat1", "serie" => "ser3", "value" => 6, "datestamp" => 2014_10_03 },
        { "category" => "cat2", "serie" => "ser1", "value" => 8, "datestamp" => 2014_10_04 },
        { "category" => "cat2", "serie" => "ser2", "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:column) do
      {
        series: [
          ["ser1", 10],
          ["ser2", 9],
          ["ser3", 6],
          ["ser1", 8],
          ["ser2", 7]]
      }
    end

    it "return highchart column format" do
      expect(Export.serie_value(cursor)).to eq(column)
    end
  end

  describe "when timeseries" do
    let(:cursor) do
      [
        { "value" => 10, "datestamp" => 2014_10_01 },
        { "value" => 9, "datestamp" => 2014_10_02 },
        { "value" => 6, "datestamp" => 2014_10_03 },
        { "value" => 8, "datestamp" => 2014_10_04 },
        { "value" => 7, "datestamp" => 2014_10_05 }
      ]
    end
    let(:timeseries) do
      {
        series: [
          [TimeHelper.datestamp_to_js(2014_10_01), 10],
          [TimeHelper.datestamp_to_js(2014_10_02), 9],
          [TimeHelper.datestamp_to_js(2014_10_03), 6],
          [TimeHelper.datestamp_to_js(2014_10_04), 8],
          [TimeHelper.datestamp_to_js(2014_10_05), 7],
          [TimeHelper.datestamp_to_js(Time.now.strftime("%Y%m%d")), 7]
        ]
      }
    end

    it "returns highchart timeseries format" do
      expect(Export.timeseries(cursor)).to eq(timeseries)
    end
  end

  describe "when boxplot" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "observation1", "min" => 1, "first_quartil" => 6, "median" => 12, "third_quartil" => 31, "max" => 45 },
        { "category" => "cat2", "serie" => "observation1", "min" => 2, "first_quartil" => 7, "median" => 22, "third_quartil" => 32, "max" => 46 },
        { "category" => "cat1", "serie" => "observation2", "min" => 3, "first_quartil" => 8, "median" => 32, "third_quartil" => 33, "max" => 47 },
        { "category" => "cat2", "serie" => "observation2", "min" => 4, "first_quartil" => 9, "median" => 42, "third_quartil" => 34, "max" => 48 },
      ]
    end
    let(:boxplot) do
      {
        categories: %w(cat1 cat2),
        series: [
          {
            name: "observation1",
            data: [
              [1, 6, 12, 31, 45],
              [2, 7, 22, 32, 46]
            ]
          },
          {
            name: "observation2",
            data: [
              [3, 8, 32, 33, 47],
              [4, 9, 42, 34, 48]
            ]
          }
        ]
      }
    end

    it "return highchart boxplot format" do
      expect(Export.boxplot(cursor)).to eq(boxplot)
    end
  end

  describe "when small_heatmap" do
    let(:cursor) do
      [
        { "x_category" => "cat1", "y_category" => "ser1", "value" => 1 },
        { "x_category" => "cat1", "y_category" => "ser2", "value" => 9 },
        { "x_category" => "cat1", "y_category" => "ser3", "value" => 6 },
        { "x_category" => "cat2", "y_category" => "ser1", "value" => 8 },
        { "x_category" => "cat2", "y_category" => "ser2", "value" => 7 }
      ]
    end
    let(:small_heatmap) do
      {
        x_category: %w(cat1 cat2),
        y_category: %w(ser1 ser2 ser3),
        data: [
          [0, 0, 1], [0, 1, 9], [0, 2, 6],
          [1, 0, 8], [1, 1, 7], [1, 2, 0]
        ]
      }
    end

    it "return highchart small_heatmap format" do
      expect(Export.small_heatmap(cursor)).to eq(small_heatmap)
    end
  end

  describe "when large_heatmap" do
    let(:cursor) do
      [
        { "x_category" => "cat1", "y_category" => "ser1", "value" => 1 },
        { "x_category" => "cat1", "y_category" => "ser2", "value" => 9 },
        { "x_category" => "cat1", "y_category" => "ser3", "value" => 6 },
        { "x_category" => "cat2", "y_category" => "ser1", "value" => 8 },
        { "x_category" => "cat2", "y_category" => "ser2", "value" => 7 }
      ]
    end
    let(:large_heatmap) do
      {
        x_category: %w(cat1 cat2),
        y_category: %w(ser1 ser2 ser3),
        data: "0,0,1\n0,1,9\n0,2,6\n1,0,8\n1,1,7\n1,2,0\n"
      }
    end

    it "return highchart large_heatmap format" do
      expect(Export.large_heatmap(cursor)).to eq(large_heatmap)
    end
  end

  describe "when to_scatter" do
    let(:cursor) do
      [
        { "serie" => "ser1", "x" => 1, "y" => 1, "value" => 1 },
        { "serie" => "ser1", "x" => 1, "y" => 2, "value" => 9 },
        { "serie" => "ser2", "x" => 1, "y" => 3, "value" => 6 },
        { "serie" => "ser2", "x" => 2, "y" => 1, "value" => 8 },
        { "serie" => "ser1", "x" => 2, "y" => 2, "value" => 7 }
      ]
    end
    let(:scatter) do
      {
        series: [
          { name: "ser1", color: "hsla(102, 70%, 50%, 0.5)", data: [[1, 1], [1, 2], [2, 2]] },
          { name: "ser2", color: "hsla(348, 70%, 50%, 0.5)", data: [[1, 3], [2, 1]] }
        ]
      }
    end

    it "return scatter format" do
      expect(Export.scatter(cursor)).to eq(scatter)
    end
  end

  describe "when fixed_placement_column" do
    let(:cursor) do
      [
        { "category" => "cat1", "serie" => "ser1", "value" => 10 },
        { "category" => "cat1", "serie" => "ser2", "value" => 9 },
        { "category" => "cat1", "serie" => "ser3", "value" => 8 },
        { "category" => "cat1", "serie" => "ser4", "value" => 7 },
        { "category" => "cat2", "serie" => "ser1", "value" => 1 },
        { "category" => "cat2", "serie" => "ser2", "value" => 2 },
        { "category" => "cat2", "serie" => "ser3", "value" => 3 },
        { "category" => "cat2", "serie" => "ser4", "value" => 4 }

      ]
    end
    let(:fixed_placement_column) do
      {
        categories: %w(cat1 cat2),
        series: [
          { name: "ser1", data: [10, 1], color: "rgba(165,170,217,1)", pointPlacement: -0.2,  pointPadding: 0.3 },
          { name: "ser2", data: [9, 2], color: "rgba(248,161,63,1)", pointPlacement: 0.2,  pointPadding: 0.3 },
          { name: "ser3", data: [8, 3], color: "rgba(126,86,134,.9)", pointPlacement: -0.2,  pointPadding: 0.4, yAxis: 1 },
          { name: "ser4", data: [7, 4], color: "rgba(186,60,61,.9)", pointPlacement: 0.2,  pointPadding: 0.4, yAxis: 1 }
        ]
      }
    end

    it "return fixed_placement_column format" do
      expect(Export.fixed_placement_column(cursor)).to eq(fixed_placement_column)
    end
  end
end

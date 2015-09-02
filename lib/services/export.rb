# -*- encoding : utf-8 -*-
class Export
  include Virtus.model

  attribute :cursor

  def to_csv
    cursor.each_with_object(rows: []) do |row, hash|
      hash[:header] = row.keys unless hash[:header]
      hash[:rows] << row.values
    end
  end

  def to_column_stacked
    tmp = {}
    series_name = cursor.map do |row|
      tmp[row[:category]] ||= {}
      tmp[row[:category]][row[:serie]] = row[:value]
      row[:serie]
    end.uniq.sort

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn.presence || "none", data: [] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn] || 0
        end
      end
    end
  end
  alias_method :to_column_stacked_normal, :to_column_stacked
  alias_method :to_column_stacked_percent, :to_column_stacked
  alias_method :to_windrose, :to_column_stacked
  alias_method :to_basic_area, :to_column_stacked
  alias_method :to_stacked_area, :to_column_stacked
  alias_method :to_area_stacked_percent, :to_column_stacked
  alias_method :to_basic_line, :to_column_stacked
  alias_method :to_multiple_column, :to_column_stacked
  alias_method :to_spiderweb, :to_column_stacked

  def to_column
    cursor.each_with_object(series: []) do |row, hash|
      hash[:series] << [row[:serie], row[:value]]
    end
  end
  alias_method :to_pie_chart, :to_column
  alias_method :to_half_donuts, :to_column
  alias_method :to_funnel, :to_column

  def to_column_stacked_grouped
    tmp = {}
    series_name = cursor.map do |row|
      tmp[row[:category]] ||= {}
      tmp[row[:category]][row[:serie]] = row[:value]
      { name: row[:serie], stack: row[:stack] }
    end.uniq
    series_name.sort! { |a, b| a[:name] <=> b[:name] }

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn[:name].presence || "none", data: [], stack: sn[:stack] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn[:name]] || 0
        end
      end
    end

  end

  def to_timeseries
    { series: [] }.tap do |hash|
      cursor.each do |row|
        hash[:series] << [datestamp(row[:datestamp]), row[:value]]
      end
      hash[:series] << [datestamp, hash[:series].last[1]]
    end
  end

  def to_json_value
    cursor.reduce({}) do |hash, row|
      indent(row.keys, row, hash, true)
    end
  end
  alias_method :to_treemap2, :to_json_value
  alias_method :to_treemap3, :to_json_value

  def to_json_array
    cursor.reduce({}) do |hash, row|
      indent(row.keys, row, hash, false)
    end
  end

    def to_multiple_csv
      cursor.each_with_object(header: [], rows: {}) do |row, hash|
        group_by = row.delete(row.first.first)
        hash[:rows][group_by] ||= []
        hash[:rows][group_by] << row.values
        hash[:header] = row.keys.map(&:to_s)
      end
    end

  def to_value
    cursor.each_with_object(value: 0) do |row, hash|
      row.values.each do |v|
        hash[:value] = v
      end
    end
  end

  def to_leaflet
    tmp = {}
    cursor.each do |row|
      tmp[row[:layer_name]] ||= { type: "FeatureCollection", features: [] }
      # Define properties
      ppt = row.keys - [:collection, :type, :geometry_type, :lat, :lng, :layer_name]
      tmp2 = {}
      ppt.each do |k|
        tmp2[k] = row[k]
      end
      # End properties
      tmp[row[:layer_name]][:features] << { type: row[:type], geometry: { type: row[:geometry_type], coordinates: [row[:lng], row[:lat]] }, properties: tmp2 }
    end
    tmp
  end

  def to_boxplot
    tmp = {}
    series_name = cursor.map do |row|
      tmp[row[:category]] ||= {}
      tmp[row[:category]][row[:serie]] = [row[:min], row[:first_quartil], row[:median], row[:third_quartil], row[:max]]
      row[:serie]
    end.uniq

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn.presence || "none", data: [] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn] || 0
        end
      end
    end
  end

  def to_small_heatmap
    res = { x_category: [], y_category: [], data: [] }
    tmp = {}
    cursor.each do |row|
      res[:x_category] << row[:x_category] unless res[:x_category].include?(row[:x_category])
      res[:y_category] << row[:y_category] unless res[:y_category].include?(row[:y_category])
      tmp[row[:x_category]] ||= {}
      tmp[row[:x_category]][row[:y_category]] = row[:value]
    end

    res[:x_category].each_with_index do |x_cat, y|
      res[:y_category].each_with_index do |y_cat, x|
        value = tmp[x_cat][y_cat] ? tmp[x_cat] && tmp[x_cat][y_cat] : 0
        res[:data] << [y, x, value]
      end
    end

    res
  end

  def to_large_heatmap
    res = { x_category: [], y_category: [], data: "" }
    tmp = {}
    cursor.each do |row|
      res[:x_category] << row[:x_category] unless res[:x_category].include?(row[:x_category])
      res[:y_category] << row[:y_category] unless res[:y_category].include?(row[:y_category])
      tmp[row[:x_category]] ||= {}
      tmp[row[:x_category]][row[:y_category]] = row[:value]
    end

    res[:x_category].each_with_index do |x_cat, y|
      res[:y_category].each_with_index do |y_cat, x|
        value = tmp[x_cat][y_cat] ? tmp[x_cat] && tmp[x_cat][y_cat] : 0
        res[:data] << "#{y},#{x},#{value}\n"
      end
    end
    res
  end

  def to_scatter
    tmp = {}
    cursor.each do |row|
      tmp[row[:serie]] ||= []
      tmp[row[:serie]] << [row[:x], row[:y]]
    end

    rnd = Random.new(42)
    tmp.keys.each_with_object(series: []) do |sn, res|
      res[:series] << { name: sn || "none", color: "hsla(#{rnd.rand(360)}, 70%, 50%, 0.5)", data: tmp[sn] }
    end
  end

  def to_fixed_placement_column
    tmp = {}
    cpt = 0

    series_name = cursor.map do |row|
      tmp[row[:category]] ||= {}
      tmp[row[:category]][row[:serie]] = row[:value]
      row[:serie]
    end.uniq

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn.presence || "none", data: [] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn] || 0
        end

        case cpt
          when 0
            serie[:color] = "rgba(165,170,217,1)"
            serie[:pointPlacement] = -0.2
            serie[:pointPadding] = 0.3
          when 1
            serie[:color] = "rgba(248,161,63,1)"
            serie[:pointPlacement] = 0.2
            serie[:pointPadding] = 0.3
          when 2
            serie[:color] = "rgba(126,86,134,.9)"
            serie[:pointPlacement] = -0.2
            serie[:pointPadding] = 0.4
            serie[:yAxis] = 1
          when 3
            serie[:color] = "rgba(186,60,61,.9)"
            serie[:pointPlacement] = 0.2
            serie[:pointPadding] = 0.4
            serie[:yAxis] = 1
        end

        cpt += 1
      end
    end
  end


  private

  def indent(keys, hashin, hashout = {}, value = false)
    v = keys.shift
    if keys.size == 1
      if value
        hashout[hashin[v]] = hashin[keys.shift]
      else
        hashout[hashin[v]] ||= []
        hashout[hashin[v]] << hashin[keys.shift]
      end
    else
      if hashout[hashin[v]].nil?
        hashout[hashin[v]] = indent(keys, hashin, {}, value)
      else
        hashout[hashin[v]] = indent(keys, hashin, hashout[hashin[v]], value)
      end
    end
    hashout
  end

  def datestamp(time = Time.now.strftime("%Y%m%d"))
    TimeHelper.datestamp_to_js(time)
  end
end

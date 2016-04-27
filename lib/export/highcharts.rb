require_relative 'other'

module Export
  def self.category_serie_value(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    series_name = []
    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      series_name << row["serie"]
      hash[row["category"]] ||= {}
      hash[row["category"]][row["serie"]] = row["value"]
    end
    series_name.uniq!
    series_name.sort!

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn.presence || "none", data: [] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn] ? [cat, tmp[cat][sn]] : [cat, 0]
        end
      end
    end
  end
  class << self
    alias_method :column_stacked_normal, :category_serie_value
    alias_method :column_stacked_percent, :category_serie_value
    alias_method :windrose, :category_serie_value
    alias_method :basic_area, :category_serie_value
    alias_method :stacked_area, :category_serie_value
    alias_method :stacked_area_percent, :category_serie_value
    alias_method :basic_line, :category_serie_value
    alias_method :multiple_column, :category_serie_value
    alias_method :spiderweb, :category_serie_value
    alias_method :column_stacked, :category_serie_value
  end

  def self.serie_value(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    cursor.each_with_object(series: []) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      hash[:series] << [row["serie"], row["value"]]
    end
  end
  class << self
    alias_method :pie_chart, :serie_value
    alias_method :half_donuts, :serie_value
    alias_method :funnel, :serie_value
    alias_method :column, :serie_value
  end

  def self.column_stacked_grouped(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    series_name = []
    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }

      series_name << { name: row["serie"], stack: row["stack"] }

      hash[row["category"]] ||= {}
      hash[row["category"]][row["serie"]] = row["value"]
    end
    series_name.uniq!
    series_name.sort! { |a, b| a[:name] <=> b[:name] }

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn[:name].presence || "none", data: [], stack: sn[:stack] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn[:name]] || 0
        end
      end
    end
  end

  class << self
    alias_method :treemap2, :json_value
    alias_method :treemap3, :json_value
  end

  def self.boxplot(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    series_name = []
    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      series_name << row["serie"]

      hash[row["category"]] ||= {}
      hash[row["category"]][row["serie"]] = [row["min"], row["first_quartil"], row["median"], row["third_quartil"], row["max"]]
    end
    series_name.uniq!

    series_name.each_with_object(categories: tmp.keys, series: []) do |sn, res|
      res[:series] << { name: sn.presence || "none", data: [] }.tap do |serie|
        serie[:data] = res[:categories].map do |cat|
          tmp[cat][sn] || 0
        end
      end
    end
  end

  def self.small_heatmap(cursor, opts = {})
    heatmap(cursor, [], opts) { |x, y, value| [y, x, value] }
  end

  def self.large_heatmap(cursor, opts = {})
    heatmap(cursor, "", opts) { |x, y, value| "#{y},#{x},#{value}\n" }
  end

  def self.heatmap(cursor, data_in, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    res = { x_category: [], y_category: [], data: data_in }
    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }

      res[:x_category] << row["x_category"] unless res[:x_category].include?(row["x_category"])
      res[:y_category] << row["y_category"] unless res[:y_category].include?(row["y_category"])

      hash[row["x_category"]] ||= {}
      hash[row["x_category"]][row["y_category"]] = row["value"]
    end

    res[:x_category].each_with_index do |x_cat, x|
      res[:y_category].each_with_index do |y_cat, y|
        value = tmp[x_cat][y_cat] ? tmp[x_cat] && tmp[x_cat][y_cat] : 0
        res[:data] << yield(y, x, value)
      end
    end
    res
  end

  def self.scatter(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }

      hash[row["serie"]] ||= []
      hash[row["serie"]] << [row["x"], row["y"]]
    end

    rnd = Random.new(42)
    tmp.keys.each_with_object(series: []) do |sn, res|
      res[:series] << { name: sn || "none", color: "hsla(#{rnd.rand(360)}, 70%, 50%, 0.5)", data: tmp[sn] }
    end
  end

  def self.bubble(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }

      hash[row["serie"]] ||= []
      hash[row.delete("serie")] << row if %w(x y serie).all? { |k| row.key? k }
    end

    tmp.keys.each_with_object(series: []) do |sn, res|
      res[:series] << { name: sn || "none", data: tmp[sn] }
    end
  end

  def self.fixed_placement_column(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    series_name = []
    tmp = cursor.each_with_object({}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }

      series_name << row["serie"]

      hash[row["category"]] ||= {}
      hash[row["category"]][row["serie"]] = row["value"]
    end
    series_name.uniq!

    cpt = 0
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
end

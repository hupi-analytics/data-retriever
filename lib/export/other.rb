module Export
  def self.multiple_csv(cursor, opts = {})
    header = opts["header"] ? opts["header"].split(" ") : []
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    cursor.each_with_object(header: header, rows: {}) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      group_by = row.delete(row.first.first)
      hash[:rows][group_by] ||= []
      row.keys.each { |h| hash[:header] << h unless hash[:header].include?(h) } unless opts["header"]
      hash[:rows][group_by] << hash[:header].each_with_object([]) { |key, r| r << row[key] }
    end
  end

  def self.value(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    cursor.each_with_object(value: 0) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      row.values.each do |v|
        hash[:value] = v
      end
    end
  end

  def self.csv(cursor, opts = {})
    header = opts["header"] ? opts["header"].split(" ") : []
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    cursor.each_with_object(rows: [], header: header) do |row, hash|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      row.keys.each { |h|  hash[:header] << h unless hash[:header].include?(h) } unless opts["header"]
      hash[:rows] << hash[:header].each_with_object([]) { |key, r| r << row[key] }
    end
  end

  def self.cursor(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    cursor.map do |row|
      row.select! { |k| opts["header"].include?(k) } if opts["header"]
      row = row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
    end
  end

  def self.json_value(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    cursor.reduce({}) do |hash, row|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      indent(row.keys, row, hash, true)
    end
  end

  def self.json_array(cursor, opts = {})
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}
    cursor.reduce({}) do |hash, row|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      Export.indent(row.keys, row, hash, false)
    end
  end

  def self.indent(keys, hashin, hashout = {}, value = false)
    v = keys.shift
    if keys.size == 1
      if value
        hashout[hashin[v]] = hashin[keys.shift]
      else
        hashout[hashin[v]] ||= []
        hashout[hashin[v]] << hashin[keys.shift]
      end
    else
      hashout[hashin[v]] = indent(keys, hashin, hashout.fetch(hashin[v], {}), value)
    end
    hashout
  end

  def self.format_value(value, formats)
    formats ||= []
    formats.each do |f|
      value = Export.action(value, f["action"], f["params"])
    end
    value
  end

  def self.action(value, action, params)
    case action
    when "to_int"
      value.to_i
    when "to_float"
      value.to_f
    when "to_string"
      value.to_s
    when "date_string_to_timestamp"
      DateTime.strptime(value, params["input_format"]).to_time.to_i unless value.blank?
    when "date_string_format"
      DateTime.strptime(value, params["input_format"]).strftime(params["output_format"]) unless value.blank?
    when "timestamp_format"
      Time.at(value).strftime(params["output_format"]) unless value.blank?
    when "round"
      value.round(params) unless value.blank?
    when "multiply"
      value * params["by"]  unless value.blank?
    when "divide"
      value / params["by"]  unless value.blank?
    end
  end
end

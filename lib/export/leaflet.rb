module Export
  def self.leaflet(cursor, opts = {})
    tmp = {}
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    cursor.each do |row|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      tmp[row["layer_name"]] ||= { type: "FeatureCollection", features: [] }
      # Define properties
      ppt = row.keys - %w(collection type geometry_type lat lng layer_name)
      tmp2 = {}
      ppt.each do |k|
        tmp2[k] = row[k]
      end
      # End properties
      tmp[row["layer_name"]][:features] << { type: row["type"], geometry: { type: row["geometry_type"], coordinates: [row["lng"], row["lat"]] }, properties: tmp2 }
    end
    tmp
  end
end

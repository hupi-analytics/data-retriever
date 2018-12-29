module Export
  def self.leaflet(cursor, opts = {})
    tmp = {}
    val_format = !opts["format"].nil? && !opts["format"].empty? ? JSON.parse(opts["format"]) : {}

    cursor.each do |row|
      row.each { |k, v| row[k] = Export.format_value(v, val_format[k]) }
      tmp[row["layer_name"]] ||= { type: "FeatureCollection", features: [] }
      # Define properties
      ppt = row.keys - %w(collection type geometry_type lat lng layer_name coordinates)
      tmp2 = {}
      ppt.each do |k|
        tmp2[k] = row[k]
      end
      # End properties
      if row["geometry_type"] == "Point"
        tmp_coordinates = [row["lng"], row["lat"]]
      else
        tmp_coordinates = row["coordinates"]        
      end
      #tmp[row["layer_name"]][:features] << { type: row["type"], geometry: { type: row["geometry_type"], coordinates: [row["lng"], row["lat"]] }, properties: tmp2 }
      tmp[row["layer_name"]][:features] << { type: row["type"], geometry: { type: row["geometry_type"], coordinates: tmp_coordinates }, properties: tmp2 }
    end
    tmp
  end
end

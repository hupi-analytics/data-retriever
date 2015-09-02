class SQLQueryEngine < DefaultQueryEngine
  def decorate(query, client, filters = {})
    query.gsub!("#_client_#", client)
    apply_filters(query, filters)
  end

  def apply_filters(query, filters = {})
    patterns = query.scan(/#_(?<pat>(where|and)_\w+)_#/i).flatten.uniq
    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""

      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          pattern_filter << "#{f[:field]} #{f[:operator]} #{f[:value]}" if f[:value]
        end
        pattern_string += pattern =~ /where/ ? "WHERE " : "AND "
        pattern_string += pattern_filter.join(" AND ")
      end
      query.gsub!("#_#{pattern}_#", pattern_string)
    end
    query
  end
end

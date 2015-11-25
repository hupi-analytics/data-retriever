require "query_engine/default_query_engine"

class SQLQueryEngine < DefaultQueryEngine
  def decorate(query, filters = {}, query_params = {})
    query.gsub!("#_client_#", @client)
    apply_filters(query, filters)
    apply_params(query, query_params)
    query
  end

  private

  def apply_filters(query, filters = {})
    filters ||= {}
    patterns = query.scan(/#_(?<pat>(where|and)_\w+)_#/i).flatten.uniq
    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""

      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          val = f[:value_type].downcase == "string" ? "'#{f[:value]}'" : f[:value]
          pattern_filter << "(#{f[:field]} #{f[:operator]} #{val})" if f[:value]
        end
        pattern_string += pattern =~ /where/ ? "WHERE " : "AND "
        pattern_string += pattern_filter.join(" AND ")
      end
      query.gsub!("#_#{pattern}_#", pattern_string)
    end
    query
  end

  def apply_params(query, query_params = {})
    query_params ||= {}
    query_params.each do |pattern, value|
      query.gsub!("#_#{pattern}_#", value)
    end
    query
  end
end

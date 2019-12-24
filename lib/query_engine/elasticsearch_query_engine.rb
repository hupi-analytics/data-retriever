require "elasticsearch"
require "query_engine/default_query_engine"

class ElasticsearchQueryEngine < DefaultQueryEngine
  def connect
    @connexion = Elasticsearch::Client.new @settings
  end

  def execute(query, _)
    result = @connexion.search query
    parse_search_result(result)
  end

  def close
    # @connexion.close
  end

  def decorate(query, filters = {}, query_params = {})
    apply_params(query, query_params)
    apply_filters(query, filters)
    JSON.parse(query, symbolize_names: true)
  end

  def explain(query, _)
    @connexion.explain query
  end

  private

  def apply_filters(query, filters = {})
    filters ||= {}
    patterns = query.scan(/#_(?<pat>(sub)_\w+)_#/i).flatten.uniq

    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""
      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          val = case f[:value_type].downcase
                when "string"
                  "\"#{f[:value]}\""
                when "hash"
                  f[:value].is_a?(Hash) ? f[:value].to_json : f[:value].to_s
                when "array"
                  f[:value].is_a?(Array) ? f[:value].to_json : f[:value].to_s
                else
                  f[:value].to_s
                end
          if pattern =~ /sub/
            pattern_filter << f[:operator].gsub("#_value_#", val)
          end
        end
        pattern_string << pattern_filter.join(",")
      end
      pattern_string << "," if pattern =~ /sub_and/ && !pattern_string.empty?
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

  def parse_search_result(result)
    DataRetriever::API.logger.error "result : #{result}"
    if result["aggregations"]
      [result["aggregations"]]
    elsif result.fetch("hits", {}).fetch("total", 0) > 0
      result["hits"]["hits"].map { |row| row.fetch("_source", {}).merge("id" => row["_id"]).merge(row.fetch("fields", {})) }
    else
      []
    end
  end
end

require "mongo"
require "query_engine/default_query_engine"

class MongodbQueryEngine < DefaultQueryEngine
  def connect
    @connexion = Mongo::Client.new(@settings[:hosts], @settings)
  end

  def execute(query, _)
    result = @connexion.use(@database)[query["collection"]]
    query["query"].each do |operation|
      result = case operation["operator"]
               when "aggregate"
                 result.send(:aggregate, operation["pipeline"], operation["opts"] || {})
               when "find"
                 result.send(:find, operation["filter"], operation["opts"] || {})
               when "map_reduce"
                 result.send(:map_reduce, operation["map"], operation["reduce"], operation["opts"] || {})
               end
    end
    result
  end

  def explain(query, info)
    execute(query, info).explain
  end

  def close
    @connexion.close
  end

  def decorate(query, filters = {}, query_params = {})
    apply_params(query, query_params)
    apply_filters(query, filters)
    JSON.parse(query)
  end

  private

  def apply_filters(query, filters = {})
    filters ||= {}
    patterns = query.scan(/#_(?<pat>(match|find|and)_\w+)_#/i).flatten.uniq

    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""
      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          val = case f[:value_type].downcase
                when "string"
                  "\"#{f[:value]}\""
                else
                  f[:value]
                end
          pattern_filter << if f[:operator] == "$eq"
                              "{ \"#{f[:field]}\": #{val} }"
                            else
                              "{ \"#{f[:field]}\": { \"#{f[:operator]}\": #{val} } }"
                            end
        end

        case pattern
        when /match/
          pattern_string << "{ \"$match\": { \"$and\": ["
          pattern_string << pattern_filter.join(", ")
          pattern_string << "] } },"
        when /find/
          pattern_string << "\"$and\": ["
          pattern_string << pattern_filter.join(", ")
          pattern_string << "]"
        when /and/
          pattern_string << ","
          pattern_string << pattern_filter.join(", ")
        end
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

require "time"
require "net/http"
require "json"
require "query_engine/default_query_engine"

class HttpQueryEngine < DefaultQueryEngine
  def connect
    @host = @settings.fetch(:http_host)
    @port = @settings.fetch(:http_port)
    @query_string = @settings.fetch(:http_query_string)
  end

  def execute(query, info)
    model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    res = predict(query, model_name)
    parse_result(res)
  end

  def close
  end

  def decorate(query, filters = {}, query_params = nil)
    if query_params && !query_params.empty?
      {predict: query_params}
    else
      query.gsub!("#_client_#", @client)
      apply_filters(query, filters)
      query
    end
  end

  def explain(query, info)
    #model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    uri = URI("http://#{@host}:#{@port}/#{@query_string}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new uri
    req.content_type = "application/json"
    res = https.request(req)
    JSON.parse(res.body)
  end

  private

  def apply_filters(query, filters = {})
    filters ||= {}
    patterns = query.scan(/#_(?<pat>(replace)_\w+)_#/i).flatten.uniq

    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""
      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          pattern_filter = case f[:value_type].downcase
                when "string"
                  "#{f[:value]}"
                else
                  "#{f[:value]}"
                end
        end

        case pattern
        when /replace/
          pattern_string << pattern_filter
        end
      end
      query.gsub!("#_#{pattern}_#", pattern_string)
    end
    query
  end

  def parse_result(result)
    result.value
    [JSON.parse(result.body),{}]
  end

  def predict(query, model_name)
    query = JSON.parse(query)
    body = (query[:predict] || query).to_json
    uri = URI("http://#{@host}:#{@port}/#{@query_string}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new uri
    req.content_type = "application/json"
    req.body = body
    https.request(req)
  end

end

require "time"
require "net/http"
require "json"
require "query_engine/default_query_engine"

class HttpQueryEngine < DefaultQueryEngine
  def connect
    @host = @settings.fetch(:http_host)
    @port = @settings.fetch(:http_port)
  end

  def execute(query, info)
    model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    res = predict(query, model_name)
    parse_result(res)
  end

  def close
  end

  def decorate(query, _filters = {}, query_params = {})
    {predict: query_params}
  end

  def explain(query, info)
    #model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    uri = URI("http://#{@host}:#{@port}/predict")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new uri
    req.content_type = "application/json"
    res = https.request(req)
    JSON.parse(res.body)
  end

  private

  def apply_filters(query, filters = {})
  end

  def parse_result(result)
    result.value
    [JSON.parse(result.body),{}]
  end

  def predict(query, model_name)
    body = query[:predict].to_json
    uri = URI("http://#{@host}:#{@port}/predict")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new uri
    req.content_type = "application/json"
    req.body = body
    https.request(req)
  end

end

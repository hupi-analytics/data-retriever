require "time"
require "net/http"
require "json"
require "securerandom"
require "query_engine/default_query_engine"

class OpenscoringQueryEngine < DefaultQueryEngine
  def connect
    @host = @settings.fetch(:host)
    @port = @settings.fetch(:port)
  end

  def execute(query, info)
    model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    check_model(query[:pmml], model_name, info.fetch(:updated_at))
    res = predict(query, model_name)
    parse_result(res, query[:predict][:id])
  end

  def close
  end

  def decorate(query, _filters = {}, query_params = {})
    res_query = { pmml: query, predict: { id: SecureRandom.hex, arguments: {} } }
    apply_params(res_query, query_params)
    res_query
  end

  def explain(query, info)
    model_name = "#{info.fetch(:module_name)}_#{info.fetch(:method_name)}_#{info.fetch(:query_object_name)}"
    check_model(query[:pmml], model_name, info.fetch(:updated_at))
    uri = URI("http://#{@host}:#{@port}/openscoring/model/#{model_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new uri
    req.content_type = 'application/json'
    res = https.request(req)
    JSON.parse(res.body)
  end

  private

  def apply_filters(query, filters = {})
  end

  def apply_params(query, query_params = {})
    query[:predict][:arguments] = query_params
    query
  end

  def parse_result(result, prediction_id)
    result.value
    res = JSON.parse(result.body)
    if res.fetch("id") == prediction_id
      [res.fetch("result", {})]
    else
      raise "prediction id mismatch"
    end
  end

  def predict(query, model_name)
    body = query[:predict].to_json
    uri = URI("http://#{@host}:#{@port}/openscoring/model/#{model_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new uri
    req.content_type = 'application/json'
    req.body = body
    https.request(req)
  end

  def upsert_model(pmml, model_name)
    uri = URI("http://#{@host}:#{@port}/openscoring/model/#{model_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Put.new uri
    req.body = pmml
    req.content_type = 'text/xml'
    res = https.request(req)
    res.value
    true
  end

  def check_model(pmml, model_name, modified_date)
    uri = URI("http://#{@host}:#{@port}/openscoring/model/#{model_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new uri
    req.content_type = 'application/json'
    res = https.request(req)
    return upsert_model(pmml, model_name) if res.code == "404"
    res.value
    ts = JSON.parse(res.body).fetch("properties").fetch("created.timestamp")
    return upsert_model(pmml, model_name) if (modified_date - Time.strptime(ts, "%Y-%m-%dT%H:%M:%S.%L%z")) > 10
    true
  end
end

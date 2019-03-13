require "time"
require "net/http"
require "json"
require "query_engine/default_query_engine"

class HttpQueryEngine < DefaultQueryEngine
  def connect
    @host = @settings.fetch(:http_host)
    @port = @settings.fetch(:http_port)
    @query_string = @settings.fetch(:http_query_string)
    @http_call = @settings.fetch(:http_call, "Post") 
    @http_header = @settings.fetch(:http_header) if @settings.has_key?(:http_header)
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
    case @http_call
      when "Post" then 
          query = JSON.parse(query)
          body = (query[:predict] || query).to_json
          uri = URI("http://#{@host}:#{@port}/#{@query_string}")
          https = Net::HTTP.new(uri.host, uri.port)
          req = Net::HTTP::Post.new uri
          req.content_type = "application/json"
          req.body = body
          https.request(req)
      when "Get" then
          puts "HELLLLLLLL : #{@http_header}"
          uri = URI("https://#{@host}:#{@port}/#{@query_string}#{query}")
          fetch(uri).response
    end
  end

  def fetch(uri_str, limit = 10)
    # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    url = URI(uri_str)
    req = Net::HTTP::Get.new(url)
    req["Grpc-Metadata-Authorization"] = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJsb3JhLWFwcC1zZXJ2ZXIiLCJhdWQiOiJsb3JhLWFwcC1zZXJ2ZXIiLCJuYmYiOjE1MDg3NDgxNTAsImV4cCI6MTYwMDAwMDAwMCwic3ViIjoiYWRtaW4iLCJ1c2VybmFtZSI6ImFkbWluIn0.5LewbkJu3toBtbaSbPAy74kpvnZVQcSrryVrcQIZEKk'
    req["Content-Type"] = 'application/x-www-form-urlencoded'
    response = Net::HTTP.start(url.host, url.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      request = Net::HTTP::Get.new url
      response = http.request req # Net::HTTPResponse object
    end
    
    case response
     when Net::HTTPSuccess then
       response
     when Net::HTTPRedirection then
       location = response['location']
       warn "redirected to #{location}"
       fetch(location, limit - 1)
        
     else
      response.value
    end
  end
end


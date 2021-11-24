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
    @http_ssl = @settings.fetch(:http_ssl) if @settings.has_key?(:http_ssl)
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
    patterns = query.scan(/#_(?<pat>(replace|where|and|limit|offset)_\w+)_#/i).flatten.uniq
    
    patterns.each do |pattern|
      pattern_filter = []
      pattern_string = ""

      if filters[pattern] && !filters[pattern].empty?
        filters[pattern].each do |f|
          val = f[:value_type].casecmp("string").zero? ? "'#{f[:value]}'" : f[:value]
          case pattern
          when /limit/
            pattern_filter << "limit #{val}" if f[:value]
          when /offset/
            pattern_filter << "offset #{val}" if f[:value]
          when /replace/
            pattern_filter = "#{f[:value]}" # Don't take into account the adding of '' for strings
          else
            pattern_filter << "(#{f[:field]} #{f[:operator]} #{val})" if f[:value]
          end
        end
        if (pattern =~ /where/) || (pattern =~ /and/)
          pattern_string += pattern =~ /where/ ? "WHERE " : "AND "
          pattern_string += pattern_filter.join(" AND ")
        elsif (pattern =~ /replace/)
          pattern_string << pattern_filter
        else
          pattern_string += pattern_filter.join(" ")
        end
      end
      query.gsub!("#_#{pattern}_#", pattern_string)
    end
    query
  end

  def parse_result(result)
    if @http_call == "PostKylin" then
      raw_body =  JSON.parse(result.body)
      headers = []
      raw_body["columnMetas"].each{ |raw_hash| headers.append(raw_hash["label"]) }

      parsed_body = []
      raw_body["results"].each{ |row| 
        parsed_row = {}
        row.each_with_index {|value, index| 
          if headers[index] == "value" then 
            parsed_row[headers[index]] = value.to_i
          else
            parsed_row[headers[index]] = value
          end
        }
        parsed_body.append(parsed_row)
      }
      # p parsed_body
      
    else 
      parsed_body = [JSON.parse(result.body), {}]
    end

    result.value
    parsed_body
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
      when "PostKylin" then
        postKylin(query)
      when "Get" then
        uri = URI("http#{@http_ssl == "true" ? 's' : ''}://#{@host}:#{@port}/#{@query_string}#{query}")
          fetch(uri).response
    end
  end

  def fetch(uri_str, limit = 10)
    # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    url = URI(uri_str)
    req = Net::HTTP::Get.new(url)
    
    #Par défaut les http_header sont des tableaux de Hash, il faut donc reaffecter les valeurs
    @http_header.each do |key, value|
      req[key.to_s] = value.to_s
    end unless @http_header.nil?
    
    response = Net::HTTP.start(url.host, url.port, :use_ssl =>  @http_ssl == "true", :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
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

  def postKylin(query)
    uri_str = "https://#{@host}:#{@port}/#{@query_string}"

    # Get authorization token (key = authorization, val = ...)
    header_key = @http_header.split(':')[0]
    header_val = @http_header.split(':')[1]

    body = query
    uri = URI(uri_str)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new uri
    req.content_type = "application/json"
    #req[header] = Settings.kylin.auth_token
    req[header_key] = header_val
    req.body = body

    # Log headers and body for debug
    logstr = "KYLIN Request: HEADERS:\n"
    req.each_header { |header| logstr << "  " << header << ": " << req[header] << "\n" }
    logstr << "BODY:\n" << req.body
    logger.debug(logstr)

    https.request(req)

  end

end


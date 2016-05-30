class DefaultQueryEngine
  def initialize(client, settings)
    settings.keys.each { |key| settings[key.to_sym] = settings.delete(key) }
    @settings = settings
    @client = client
    @database = settings.delete(:database) || client
    @logger = logger
  end

  def connect; end

  def close; end

  # should return an enumerator
  def execute(query, info = {}); end

  def explain(query, info = {}); end

  def reload
    close
    connect
  end

  def decorate(query, filters = {}, query_params = {}); end

  def logger
    @logger
  end
end

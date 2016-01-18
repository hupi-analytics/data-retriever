class DefaultQueryEngine
  def initialize(client, settings)
    settings.keys.each { |key| settings[key.to_sym] = settings.delete(key) }
    @settings = settings
    @client = client
    @database = settings.delete(:database) || client
  end

  def connect;  end

  def close; end

  # should return an enumerator
  def execute(query); end

  def reload
    close
    connect
  end

  def decorate(query, filters = {}, query_params = {}); end
end

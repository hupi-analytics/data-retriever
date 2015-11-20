class DefaultQueryEngine
  def initialize(settings)
    settings.keys.each { |key| settings[key.to_sym] = settings.delete(key) }
    @settings = settings
  end

  def connect; end

  def close; end

  # should return an enumerator
  def execute(query, client); end

  def decorate(query, client, filters = {}, query_params = {}); end
end

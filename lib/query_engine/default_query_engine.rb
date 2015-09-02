class DefaultQueryEngine
  def initialize(settings)
    settings.keys.each{ |key| settings[key.to_sym] = settings.delete(key) }
    @settings = settings
    # connect
  end

  def connect; end

  def close; end

  # should return an enumerator
  def execute(query); end
end

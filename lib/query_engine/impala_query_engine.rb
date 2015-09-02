require "impala"
class ImpalaQueryEngine < SQLQueryEngine
  def connect
    @conn = Impala.connect(@settings[:host], @settings[:port])
  end

  def execute(query, client, filters = {})
    @conn.execute(decorate(query, client, filters))
  end

  def close
    @conn.close
  end
end

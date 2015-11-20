require "impala"
require "query_engine/sql_query_engine"

class ImpalaQueryEngine < SQLQueryEngine
  def connect
    @connexion = Impala.connect(@settings[:host], @settings[:port])
  end

  def execute(query, client)
    cursor = []
    @connexion.execute("use #{client}")
    @connexion.execute(query).each do |row|
      cursor << row.inject({}) { |memo, (k,v)| memo[k.to_s] = v; memo }
    end
    cursor
  end

  def close
    @connexion.close
  end
end

require "impala"
require "query_engine/sql_query_engine"

class ImpalaQueryEngine < SQLQueryEngine
  def connect
    @connexion = Impala.connect(@settings[:host], @settings[:port])
    @connexion.execute("use #{@client}")
  end

  def execute(query)
    cursor = []
    @connexion.execute(query).each do |row|
      cursor << row.inject({}) { |memo, (k,v)| memo[k.to_s] = v; memo }
    end
    cursor
  end

  def close
    @connexion.close
  end
end

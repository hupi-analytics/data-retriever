require "impala"
require "query_engine/sql_query_engine"

class ImpalaQueryEngine < SQLQueryEngine
  def connect
    @connexion = Impala.connect(@settings[:host], @settings[:port])
    @connexion.execute("use #{@database}")
  end

  def execute(query, _)
    cursor = []
    @connexion.execute(query).each do |row|
      cursor << row.inject({}) { |memo, (k,v)| memo[k.to_s] = v; memo }
    end
    cursor
  end

  def close
    begin
      @connexion.close
    rescue IOError => e
      Airbrake.notify(e, parameters: { info: "Impala not closed properly" })
      DataRetriever::API.logger.error "Impala not closed properly"
    end
  end
end

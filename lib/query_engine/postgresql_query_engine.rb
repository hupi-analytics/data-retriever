require "pg"
require "query_engine/sql_query_engine"

class PostgresqlQueryEngine < SQLQueryEngine
  def connect
    @connexion = PG.connect(@settings.merge(dbname: @database))
    @connexion.type_map_for_results = PG::BasicTypeMapForResults.new @connexion
  end

  def execute(query)
    @connexion.exec(query)
  end

  def close
    @connexion.close
  end
end

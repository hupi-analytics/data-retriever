require "presto-client"
require "query_engine/sql_query_engine"

class PrestoQueryEngine < SQLQueryEngine
  def connect
    @connexion = Presto::Client.new(@settings)
  end

  def execute(query, _)
    @connexion.run_with_names(query)
  end
end

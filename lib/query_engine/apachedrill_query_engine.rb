require "drill-sergeant"
require "query_engine/sql_query_engine"

class ApachedrillQueryEngine < SQLQueryEngine
  def connect
    @connexion = Drill.new(@settings)
  end

  def execute(query, _)
    @connexion.query(query)
  end
end

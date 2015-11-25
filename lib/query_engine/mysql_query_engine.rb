require "mysql2"
require "query_engine/sql_query_engine"

class MysqlQueryEngine < SQLQueryEngine
  def connect
    @connexion = Mysql2::Client.new(@settings)
    @connexion.select_db(@client)
  end

  def execute(query)
    cursor = @connexion.query(query)
  end

  def close
    @connexion.close
  end
end

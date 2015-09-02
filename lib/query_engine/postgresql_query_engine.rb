require "pg"
class PostgresqlQueryEngine < SQLQueryEngine
  def connect
    @conn = PG.connect(@settings)
    @conn.type_map_for_results = PG::BasicTypeMapForResults.new @conn
  end

  def execute(query, client, filters = {})
    cursor = []
    @conn.exec(decorate(query, client, filters)).each do |row|
      cursor << row.inject({}) { |memo, (k,v)| memo[k.to_sym] = v; memo }
    end
    cursor
  end

  def close
    @conn.close
  end
end

require "presto-client"
require "query_engine/default_query_engine"
require "lib/core_extensions/json/decode" # For json parsing


class PrestoQueryEngine < DefaultQueryEngine
  def connect
    @connexion = Presto::Client.new(@settings)
  end

  def execute(query, _)
    @connexion.run(query)
  end
end

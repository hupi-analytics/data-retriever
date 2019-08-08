require "presto-client"
require "query_engine/default_query_engine"
require "lib/core_extensions/json/decode" # For json parsing


class PrestoQueryEngine < DefaultQueryEngine
  def connect
    @settings[:database] = @database
<<<<<<< HEAD
    @settings[:server] = @settings[:hosts]
    @connexion = Presto::Client.new(@settings)
=======
    @connexion = Presto::Client.new(server: @settings[:hosts], @settings)
>>>>>>> 8b7b0b0646d70ab1f5c9075d7c09bca64d2273ce
  end

  def execute(query, _)
    @connexion.run_with_names(query)
  end
end

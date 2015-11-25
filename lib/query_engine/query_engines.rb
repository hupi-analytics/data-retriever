module DataRetriever
  module QueryEngines
    ALL_QUERY_ENGINES = {}
    def self.get(qe, client)
      ALL_QUERY_ENGINES["#{qe.name}_#{client}"] ||= qe.init(client)
    end
  end
end

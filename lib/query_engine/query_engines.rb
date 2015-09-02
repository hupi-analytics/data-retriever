module DataRetriever
  module QueryEngines
    ALL_QUERY_ENGINES = {}
    def self.get(qe)
      ALL_QUERY_ENGINES[qe.name] ||= qe.init
    end
  end
end

module DataRetriever
  module QueryEngines
    ALL_QUERY_ENGINES = {}
    def self.get(qe, client)
      ALL_QUERY_ENGINES["#{qe.name}_#{client}"] ||= qe.init(client)
    end

    def self.reload_query_engine qe, client
      old_qe = ALL_QUERY_ENGINES["#{qe.name}_#{client}"]
      if old_qe
        old_qe.close
        ALL_QUERY_ENGINES["#{qe.name}_#{client}"] = nil
        self.get(qe, client)
      end
    end
  end
end

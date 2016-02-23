module CoreExtensions
  module BigDecimal
    module Serialization
      def as_json(options = nil)
        self.to_f
      end
    end
  end
end

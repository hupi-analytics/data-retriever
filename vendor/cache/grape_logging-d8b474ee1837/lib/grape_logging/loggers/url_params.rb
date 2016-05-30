module GrapeLogging
  module Loggers
    class UrlParams < GrapeLogging::Loggers::Base
      def parameters(request, _)
        { params: request.env["api.endpoint"].params.to_h }
      end
    end
  end
end

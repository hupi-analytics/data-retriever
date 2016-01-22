# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class Base < Grape::API
      mount DataRetriever::V1::Admin::Account
      mount DataRetriever::V1::Admin::Index
      mount DataRetriever::V1::Admin::Default
      mount DataRetriever::V1::Estimate
      mount DataRetriever::V1::ApiEndpoint
    end
  end
end

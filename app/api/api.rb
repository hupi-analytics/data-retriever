# -*- encoding : utf-8 -*-
require 'grape-swagger'
module DataRetriever
  class API < Grape::API
    version 'v1', :using => :accept_version_header

    mount DataRetriever::V1::Base
    add_swagger_documentation
  end
end

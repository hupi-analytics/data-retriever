# -*- encoding : utf-8 -*-
require "grape-entity"
require "grape_logging"

$LOAD_PATH.unshift(Grape::ROOT)
$LOAD_PATH.unshift(File.join(Grape::ROOT,'lib'))

#require all lib
Dir[File.expand_path("lib/**/*.rb", Grape::ROOT)].each do |lib|
  require lib
end
Dir[File.expand_path("lib/*.rb", Grape::ROOT)].each do |lib|
  require lib
end

#require models
Dir[File.expand_path("app/models/*.rb", Grape::ROOT)].each do |model|
  require model
end

#require all module
Dir[File.expand_path("app/api/*/*/*.rb", Grape::ROOT)].each do |modul|
  require modul
end

#require endpoint
Dir[File.expand_path("app/api/*/*.rb", Grape::ROOT)].each do |api_base|
  require api_base
end

#require all api versions
Dir[File.expand_path("app/api/*.rb", Grape::ROOT)].each do |api|
  require api
end

#serialize big decimal to float when json
BigDecimal.prepend CoreExtensions::BigDecimal::Serialization

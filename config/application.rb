# -*- encoding : utf-8 -*-
require "grape"
require "grape-entity"
require "impala"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "api"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# require all lib
Dir[File.expand_path("../../lib/*.rb", __FILE__)].each do |lib|
  require lib
end
Dir[File.expand_path("../../lib/**/default_*.rb", __FILE__)].each do |lib|
  require lib
end
Dir[File.expand_path("../../lib/**/sql_*.rb", __FILE__)].each do |lib|
  require lib
end
Dir[File.expand_path("../../lib/**/*.rb", __FILE__)].each do |lib|
  require lib
end

Dir[File.expand_path("../../app/models/*.rb", __FILE__)].each do |model|
  require model
end

# require all module
Dir[File.expand_path("../../app/api/*/module/*.rb", __FILE__)].each do |api_module|
  require api_module
end

# require endpoint
Dir[File.expand_path("../../app/api/*/base.rb", __FILE__)].each do |api_base|
  require api_base
end

# require all api versions
Dir[File.expand_path("../../app/api/*.rb", __FILE__)].each do |api|
  require api
end

# require "api"

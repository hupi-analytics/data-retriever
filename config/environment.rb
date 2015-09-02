# -*- encoding : utf-8 -*-

module DataRetriever
  ENV["RACK_ENV"] ||= "development"
  require_relative "initializer/settings"
  require_relative "initializer/errbit"
  require_relative "initializer/database"
  require_relative "environments/#{ENV['RACK_ENV']}"
  require_relative "application"
end

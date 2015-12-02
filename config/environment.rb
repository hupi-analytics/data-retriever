# -*- encoding : utf-8 -*-
require "grape"
Grape::ROOT = File.expand_path("../..", __FILE__)

module DataRetriever
  ENV["RACK_ENV"] ||= "development"

  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require "initializer/settings"
  require "initializer/errbit"
  require "initializer/database"
  require "environments/#{ENV['RACK_ENV']}"
  require "application"
end

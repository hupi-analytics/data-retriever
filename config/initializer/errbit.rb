# -*- encoding : utf-8 -*-
require "airbrake"

Airbrake.configure do |conf|
  conf.api_key = Settings.errbit.api_key
  conf.host    = Settings.errbit.host
  conf.port    = Settings.errbit.port
  conf.secure  = conf.port == 443
  conf.environment_name = ENV["RACK_ENV"]
end

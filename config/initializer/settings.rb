# -*- encoding : utf-8 -*-
require "settingslogic"

class Settings < Settingslogic
  source File.join(File.dirname(__FILE__), "..", "settings.yml")
  namespace ENV["RACK_ENV"]
end

require "active_record"
db_config = YAML.load(ERB.new(File.read("config/database.yml")).result)[ENV["RACK_ENV"]]
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)

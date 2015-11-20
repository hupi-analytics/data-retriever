# -*- encoding : utf-8 -*-
require 'grape-swagger'

module DataRetriever
  class API < Grape::API
    version 'v1', :using => :accept_version_header

    log_file = File.open(File.join(Grape::ROOT, "log", "#{ENV["RACK_ENV"]}.log"), "a")
    log_file.sync = true
    logger Logger.new GrapeLogging::MultiIO.new(STDOUT, log_file)
    logger.formatter = GrapeLogging::Formatters::Default.new
    logger.level = case Settings.log.level.downcase
    when "debug"
      Logger::DEBUG
    when "info"
      Logger::INFO
    when "warning"
      Logger::WARN
    when "error"
      Logger::ERROR
    when "fatal"
      Logger::FATAL
    else
      Logger::UNKNOWN
    end
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }

    helpers do
      def logger
        DataRetriever::API.logger
      end
    end

    mount DataRetriever::V1::Base
    add_swagger_documentation
  end
end

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
    use GrapeLogging::Middleware::RequestLogger, { logger: logger, include: [ GrapeLogging::Loggers::ClientEnv.new ] }

    helpers do
      def logger
        DataRetriever::API.logger
      end

      def authenticate!
        error!("401 Unauthorized.", 401) unless current_account
      end

      def current_account
        # find token. Check if valid
        access_token = request.headers["X-Api-Token"] || params[:token]
        @current_account ||= HdrAccount.find_by(access_token: access_token)
      end

      def convert_params(my_param)
        case my_param.class.to_s
        when "Hashie::Mash"
          my_param.to_hash
        else
          my_param
        end
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Airbrake.notify(e, parameters: env['api.endpoint'].params)
      DataRetriever::API.logger.error "#{e.message}\n-------- START BACKTRACE --------\n#{e.backtrace.join("\n")}\n-------- END   BACKTRACE --------"
      error!({ error: e.message }, 404)
    end

    rescue_from :all do |e|
      Airbrake.notify(e, parameters: env['api.endpoint'].params)
      DataRetriever::API.logger.error "#{e.message}\n-------- START BACKTRACE --------\n#{e.backtrace.join("\n")}\n-------- END   BACKTRACE --------"
      error!({ error: e.message }, 500)
    end

    mount DataRetriever::V1::Base
    add_swagger_documentation
  end
end

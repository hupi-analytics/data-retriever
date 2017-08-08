require "grape_logging"
require "logstash-logger"

log_path = File.join(Settings.log.log_path, "#{ENV['RACK_ENV']}.log")
# Custom code to include Url params which is needed by log_monitoring to include topic and client from
# Url params, so made the change to include UlrParams in api.rb file as well.
module GrapeLogging
  module Loggers
    class UrlParams < GrapeLogging::Loggers::Base
      def parameters(request, _)
        { params: request.env["api.endpoint"].params.to_h }
      end
    end
  end
end

logger_outputs = []
logger_outputs << { type: :file, path: log_path, sync: true, formatter: :json_lines }
if %w(development test).include?(ENV["RACK_ENV"])
  logger_outputs << { type: :stdout, formatter: :json_lines }
  # logger_outputs << { type: :udp, host: "localhost", port: 5228, formatter: :json_lines }
else
  # logger_outputs << { type: :kafka, hosts: Settings.log.kafka_hosts, path: "log_data-retriever", producer: "data-retriever-logger", formatter: :json_lines, max_retry: 0, poseidon_opts: { socket_timeout_ms: 100, max_send_retries: 1, ack_timeout_ms: 150 } }
end

LogStashLogger.configure do |config|
  config.customize_event do |event|
    event["environment"] = ENV["RACK_ENV"]
    event["api_name"] = "data-retriever"
  end
end

LOGGER = LogStashLogger.new(type: :multi_logger, outputs: logger_outputs)

LOGGER.level = case Settings.log.level.downcase
  when "debug"   then Logger::DEBUG
  when "info"    then Logger::INFO
  when "warning" then Logger::WARN
  when "error"   then Logger::ERROR
  when "fatal"   then Logger::FATAL
  else Logger::UNKNOWN
end

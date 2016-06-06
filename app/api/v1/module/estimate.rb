# -*- encoding : utf-8 -*-
require "yaml"
module DataRetriever
  module V1
    class Estimate < Grape::API
      format :json

      before do
        error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/
        authenticate!
      end

      desc "", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
      end
      post "estimate/:subject" do
        subject_name = params[:subject].to_sym
        unless params[subject_name].is_a?(Hash)
          logger.error(desc: "ESTIMATE ERROR", message: "params subject is empty")
          error!("params #{params[:subject]} is missing or not an object", 400)
        end
        regression_parameters = YAML.load_file(File.join(Settings.estimate.path, params[:client], "estimate", "#{params[:subject]}.yml"))
        total = 0
        invalid = []
        params[subject_name].each do |k, v|
          begin
            total += regression_parameters[k] * v.to_i
          rescue NoMethodError
            invalid << k
          end
        end
        if invalid.empty?
          {
            estimate: total.round(2),
            lower_bound: (total - regression_parameters["stdev"]).round(2),
            upper_bound: (total + regression_parameters["stdev"]).round(2)
          }
        else
          logger.error(desc: "ESTIMATE ERROR", message: "invalid keys: #{invalid}")
          error!("#{params[:subject]} settings not found: #{invalid}, try one of: #{regression_parameters.keys}", 400)
        end
      end
    end
  end
end

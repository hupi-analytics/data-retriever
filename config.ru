#\ -s puma

require_relative "config/environment"
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use Airbrake::Rack if %w(staging production).include?(ENV["RACK_ENV"])

require "rack/cors"
use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

run DataRetriever::API

#\ -s puma

require_relative 'config/environment'
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use Airbrake::Rack if %w(staging production).include?(ENV['RACK_ENV'])
run DataRetriever::API

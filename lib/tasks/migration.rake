namespace :db do
  task load_grape: :environment do
    require_relative "../../config/environment"
  end
end

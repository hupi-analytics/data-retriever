namespace :db do
  task load_grape: :environment do
    require_relative "../../config/environment"
  end

  task create_superadmin: :load_grape do
    account = HdrAccount.find_or_create_by(name: "hupi", role: "superadmin")
    puts account.inspect
  end
end

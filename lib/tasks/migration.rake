namespace :db do
  task load_grape: :environment do
    require_relative "../../config/environment"
  end

  task create_superadmin: :load_grape do
    account = HdrAccount.find_or_create_by(name: "hupi", role: "superadmin")
    puts account.inspect
  end

  task rename_engine_mongodb: :load_grape do
    HdrQueryEngine.find_each do |hqe|
      hqe.engine = "mongodb" if hqe.engine == "mongo"
      hqe.save
    end
  end
end

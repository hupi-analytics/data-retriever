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

  task rename_area_stacked: :load_grape do
    het = HdrExportType.find_by(name: "category_serie_value")
    het.render_types.delete("area_stacked_percent")
    het.render_types << "stacked_area_percent"
    het.save
  end
end

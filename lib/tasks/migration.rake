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

  task remove_timeseries: :load_grape do
    csv = HdrExportType.find_by(name: "csv")
    HdrExportType.find_by(name: "timeseries").destroy
    HdrQueryObject.includes(:hdr_export_types).where(hdr_export_types: { id: nil }).each do |hqo|
      hqo.hdr_export_types << csv
      hqo.save
      hqo.reload
      print hqo.id
      puts hqo.hdr_export_types.map(&:name)
    end
  end

  task migrate_to_v0_3: :load_grape do
    Rake::Task["db:rename_area_stacked"].execute
    Rake::Task["db:remove_timeseries"].execute
  end

  task set_blank_hqo_name_to_nil: :load_grape do
    HdrQueryObject.where(name: "").each do |hqo|
      hqo.name = nil
      hqo.save
    end
  end

  task migrate_to_v0_6: :load_grape do
    Rake::Task["db:set_blank_hqo_name_to_nil"].execute
  end

  task add_render_type_infobox: :load_grape do
    het = HdrExportType.find_by(name: "value")
    het.update(render_types: het.render_types << "infobox") unless het.render_types.include?("infobox")
    het = HdrExportType.find_by(name: "serie_value")
    het.update(render_types: het.render_types << "multiple_infobox") unless het.render_types.include?("multiple_infobox")
  end

  task migrate_to_v0_7: :load_grape do
    Rake::Task["db:add_render_type_infobox"].execute
  end
end

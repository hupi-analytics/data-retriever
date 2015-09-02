require "yaml"
require "logger"
require "active_record"
require "erb"

namespace :db do
  def create_database config
    options = { charset: "utf8", collation: "utf8_unicode_ci" }
    create_db = lambda do |config|
      ActiveRecord::Base.establish_connection config
      ActiveRecord::Base.connection.create_database config["database"], options
      ActiveRecord::Base.establish_connection config
    end

    create_db.call config

  end

  task :environment do
    DATABASE_ENV = ENV["RACK_ENV"] || "development"
    RACK_ENV = ENV["RACK_ENV"] || "development"
    MIGRATIONS_DIR = ENV["MIGRATIONS_DIR"] || "db/migrate"
  end

  task :configuration => :environment do
    @config = YAML.load(ERB.new(File.read("config/database.yml")).result)[DATABASE_ENV]
  end

  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection @config
    ActiveRecord::Base.logger = Logger.new STDOUT if @config["logger"]
  end

  desc "Create the database from config/database.yml for the current DATABASE_ENV"
  task :create => :configure_connection do
    create_database @config
  end

  desc "Drops the database for the current DATABASE_ENV"
  task :drop => :configure_connection do
    ActiveRecord::Base.connection.drop_database @config["database"]
  end

  desc "Migrate the database (options: VERSION=x, VERBOSE=false)."
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = true
    puts MIGRATIONS_DIR
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil
  end

  desc "Rolls the schema back to the previous version (specify steps w/ STEP=n)."
  task :rollback => :configure_connection do
    step = ENV["STEP"] ? ENV["STEP"].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end

  desc "Retrieves the current schema version number"
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end

  desc "Erase all tables"
  task :clear => :configure_connection do
    conn = ActiveRecord::Base.connection
    tables = conn.tables
    tables.each do |table|
      puts "Deleting #{table}"
      conn.drop_table(table, force: :cascade)
    end
  end

  desc "create migration file. Escape brackets with zsh db:generate_migration\[create_my_table\]"
  task :generate_migration, [:migration] do |_, args|
    if args[:migration]
      migration = args.migration.downcase.gsub(/\s/,"_")
      filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args.migration}.rb"
      filedir = File.join(Dir.pwd, "db", "migrate", filename)
      migration_class_name = args.migration.gsub(/_./) { |s| s[1].upcase }.sub(/^(.)/) { $1.upcase }

      migration_options = case args.migration
      when /create/i
        <<-MIGRATE_OPTS.gsub(/^\s{8}/, "")
            create_table :table_name do |t|
              t.column_type :column_name
            end
        MIGRATE_OPTS
      when /add/i
        <<-MIGRATE_OPTS.gsub(/^\s{8}/, "")
            add_column :table_name, :column_name, :column_type
        MIGRATE_OPTS
      when /remove/i
        <<-MIGRATE_OPTS.gsub(/^\s{8}/, "")
            remove_column :table_name, :column_name
        MIGRATE_OPTS
      when /rename/i
        <<-MIGRATE_OPTS.gsub(/^\s{8}/, "")
            rename_column :table_name, :old_column_name, :new_column_name
        MIGRATE_OPTS
      else
        <<-MIGRATE_OPTS.gsub(/^\s{8}/, "")
            change_table :table_name do |t|
              # t.remove :description, :name
              # t.string :part_number
              # t.index :part_number
              # t.rename :upccode, :upc_code
              # t.references :user, index: true
              t.timestamps null: false
            end
        MIGRATE_OPTS
      end

      migration_class = <<-MIGRATE_FILE.gsub(/^\s{8}/, "")
        class #{migration_class_name} < ActiveRecord::Migration
          def change
        #{migration_options.sub(/\n\z/, '')}
          end
        end
      MIGRATE_FILE
      f = File.new(filedir, "w")
      f.write migration_class
      f.close
    end
  end

  desc "populate table using seeds file"
  task :seed => :environment do
    ruby File.expand_path("../../../db/seeds.rb", __FILE__)
  end

  desc "delete all table, create table, populate table"
  task :reset => [:environment, :clear, :migrate, :seed]
end

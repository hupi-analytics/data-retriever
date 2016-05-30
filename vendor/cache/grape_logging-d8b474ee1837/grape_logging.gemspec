# -*- encoding: utf-8 -*-
# stub: grape_logging 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "grape_logging"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["aserafin"]
  s.bindir = "exe"
  s.date = "2016-04-29"
  s.description = "This gem provides simple request logging for Grape with just few lines of code you have to put in your project! In return you will get response codes, paths, parameters and more!"
  s.email = ["adrian@softmad.pl"]
  s.files = [".gitignore", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin/console", "bin/setup", "grape_logging.gemspec", "lib/grape_logging.rb", "lib/grape_logging/formatters/default.rb", "lib/grape_logging/formatters/json.rb", "lib/grape_logging/loggers/base.rb", "lib/grape_logging/loggers/client_env.rb", "lib/grape_logging/loggers/filter_parameters.rb", "lib/grape_logging/loggers/response.rb", "lib/grape_logging/loggers/url_params.rb", "lib/grape_logging/middleware/request_logger.rb", "lib/grape_logging/multi_io.rb", "lib/grape_logging/reporters/active_support_reporter.rb", "lib/grape_logging/reporters/logger_reporter.rb", "lib/grape_logging/timings.rb", "lib/grape_logging/version.rb"]
  s.homepage = "http://github.com/aserafin/grape_logging"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Out of the box request logging for Grape!"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<grape>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.8"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<grape>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.8"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<grape>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.8"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end

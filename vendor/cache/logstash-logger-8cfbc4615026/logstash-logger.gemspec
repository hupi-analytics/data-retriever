# -*- encoding: utf-8 -*-
# stub: logstash-logger 0.15.2 ruby lib

Gem::Specification.new do |s|
  s.name = "logstash-logger"
  s.version = "0.15.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Butler"]
  s.date = "2016-04-29"
  s.description = "Ruby logger that writes directly to LogStash"
  s.email = ["dwbutler@ucla.edu"]
  s.files = [".gitignore", ".rspec", ".travis.yml", "Appraisals", "CHANGELOG.md", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "gemfiles/rails_3.2.gemfile", "gemfiles/rails_4.0.gemfile", "gemfiles/rails_4.1.gemfile", "gemfiles/rails_4.2.gemfile", "lib/logstash-logger.rb", "lib/logstash-logger/configuration.rb", "lib/logstash-logger/device.rb", "lib/logstash-logger/device/balancer.rb", "lib/logstash-logger/device/base.rb", "lib/logstash-logger/device/connectable.rb", "lib/logstash-logger/device/file.rb", "lib/logstash-logger/device/io.rb", "lib/logstash-logger/device/kafka.rb", "lib/logstash-logger/device/multi_delegator.rb", "lib/logstash-logger/device/redis.rb", "lib/logstash-logger/device/socket.rb", "lib/logstash-logger/device/stderr.rb", "lib/logstash-logger/device/stdout.rb", "lib/logstash-logger/device/tcp.rb", "lib/logstash-logger/device/udp.rb", "lib/logstash-logger/device/unix.rb", "lib/logstash-logger/formatter.rb", "lib/logstash-logger/formatter/base.rb", "lib/logstash-logger/formatter/cee.rb", "lib/logstash-logger/formatter/cee_syslog.rb", "lib/logstash-logger/formatter/json.rb", "lib/logstash-logger/formatter/json_lines.rb", "lib/logstash-logger/formatter/logstash_event.rb", "lib/logstash-logger/logger.rb", "lib/logstash-logger/multi_logger.rb", "lib/logstash-logger/railtie.rb", "lib/logstash-logger/tagged_logging.rb", "lib/logstash-logger/version.rb", "logstash-logger.gemspec", "samples/example.crt", "samples/example.key", "samples/file.conf", "samples/redis.conf", "samples/ssl.conf", "samples/syslog.conf", "samples/tcp.conf", "samples/udp.conf", "samples/unix.conf", "spec/configuration_spec.rb", "spec/device/balancer_spec.rb", "spec/device/file_spec.rb", "spec/device/io_spec.rb", "spec/device/kafka_spec.rb", "spec/device/multi_delegator_spec.rb", "spec/device/redis_spec.rb", "spec/device/socket_spec.rb", "spec/device/stderr_spec.rb", "spec/device/stdout_spec.rb", "spec/device/tcp_spec.rb", "spec/device/udp_spec.rb", "spec/device/unix_spec.rb", "spec/device_spec.rb", "spec/formatter/base_spec.rb", "spec/formatter/cee_spec.rb", "spec/formatter/cee_syslog_spec.rb", "spec/formatter/json_lines_spec.rb", "spec/formatter/json_spec.rb", "spec/formatter/logstash_event_spec.rb", "spec/formatter_spec.rb", "spec/logger_spec.rb", "spec/multi_logger_spec.rb", "spec/rails_spec.rb", "spec/spec_helper.rb", "spec/syslog_spec.rb", "spec/tagged_logging_spec.rb"]
  s.homepage = "http://github.com/dwbutler/logstash-logger"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "LogStash Logger for ruby"
  s.test_files = ["spec/configuration_spec.rb", "spec/device/balancer_spec.rb", "spec/device/file_spec.rb", "spec/device/io_spec.rb", "spec/device/kafka_spec.rb", "spec/device/multi_delegator_spec.rb", "spec/device/redis_spec.rb", "spec/device/socket_spec.rb", "spec/device/stderr_spec.rb", "spec/device/stdout_spec.rb", "spec/device/tcp_spec.rb", "spec/device/udp_spec.rb", "spec/device/unix_spec.rb", "spec/device_spec.rb", "spec/formatter/base_spec.rb", "spec/formatter/cee_spec.rb", "spec/formatter/cee_syslog_spec.rb", "spec/formatter/json_lines_spec.rb", "spec/formatter/json_spec.rb", "spec/formatter/logstash_event_spec.rb", "spec/formatter_spec.rb", "spec/logger_spec.rb", "spec/multi_logger_spec.rb", "spec/rails_spec.rb", "spec/spec_helper.rb", "spec/syslog_spec.rb", "spec/tagged_logging_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<logstash-event>, ["~> 1.2"])
      s.add_runtime_dependency(%q<stud>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<poseidon>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<wwtd>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
    else
      s.add_dependency(%q<logstash-event>, ["~> 1.2"])
      s.add_dependency(%q<stud>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<poseidon>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<wwtd>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
    end
  else
    s.add_dependency(%q<logstash-event>, ["~> 1.2"])
    s.add_dependency(%q<stud>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<poseidon>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<wwtd>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
  end
end

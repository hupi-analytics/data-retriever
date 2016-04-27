# -*- encoding: utf-8 -*-
# stub: simplecov 0.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "simplecov"
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Christoph Olszowka"]
  s.date = "2016-04-29"
  s.description = "Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites"
  s.email = ["christoph at olszowka de"]
  s.files = [".gitignore", ".rspec", ".rubocop.yml", ".travis.yml", ".yardopts", "CHANGELOG.md", "CONTRIBUTING.md", "Gemfile", "MIT-LICENSE", "README.md", "Rakefile", "cucumber.yml", "doc/alternate-formatters.md", "doc/commercial-services.md", "doc/editor-integration.md", "features/config_autoload.feature", "features/config_command_name.feature", "features/config_coverage_dir.feature", "features/config_deactivate_merging.feature", "features/config_formatters.feature", "features/config_merge_timeout.feature", "features/config_nocov_token.feature", "features/config_profiles.feature", "features/config_project_name.feature", "features/config_styles.feature", "features/cucumber_basic.feature", "features/maximum_coverage_drop.feature", "features/merging_test_unit_and_rspec.feature", "features/minimum_coverage.feature", "features/refuse_coverage_drop.feature", "features/rspec_basic.feature", "features/rspec_fails_on_initialization.feature", "features/rspec_groups_and_filters_basic.feature", "features/rspec_groups_and_filters_complex.feature", "features/rspec_groups_using_filter_class.feature", "features/rspec_without_simplecov.feature", "features/skipping_code_blocks_manually.feature", "features/step_definitions/html_steps.rb", "features/step_definitions/simplecov_steps.rb", "features/step_definitions/transformers.rb", "features/step_definitions/web_steps.rb", "features/support/env.rb", "features/test_unit_basic.feature", "features/test_unit_groups_and_filters_basic.feature", "features/test_unit_groups_and_filters_complex.feature", "features/test_unit_groups_using_filter_class.feature", "features/test_unit_without_simplecov.feature", "features/unicode_compatiblity.feature", "lib/simplecov.rb", "lib/simplecov/command_guesser.rb", "lib/simplecov/configuration.rb", "lib/simplecov/defaults.rb", "lib/simplecov/exit_codes.rb", "lib/simplecov/file_list.rb", "lib/simplecov/filter.rb", "lib/simplecov/formatter.rb", "lib/simplecov/formatter/multi_formatter.rb", "lib/simplecov/formatter/simple_formatter.rb", "lib/simplecov/jruby_fix.rb", "lib/simplecov/last_run.rb", "lib/simplecov/merge_helpers.rb", "lib/simplecov/no_defaults.rb", "lib/simplecov/profiles.rb", "lib/simplecov/railtie.rb", "lib/simplecov/railties/tasks.rake", "lib/simplecov/result.rb", "lib/simplecov/result_merger.rb", "lib/simplecov/source_file.rb", "lib/simplecov/version.rb", "simplecov.gemspec", "spec/1_8_fallbacks_spec.rb", "spec/command_guesser_spec.rb", "spec/deleted_source_spec.rb", "spec/faked_project/Gemfile", "spec/faked_project/Rakefile", "spec/faked_project/cucumber.yml", "spec/faked_project/features/step_definitions/my_steps.rb", "spec/faked_project/features/support/env.rb", "spec/faked_project/features/test_stuff.feature", "spec/faked_project/lib/faked_project.rb", "spec/faked_project/lib/faked_project/framework_specific.rb", "spec/faked_project/lib/faked_project/meta_magic.rb", "spec/faked_project/lib/faked_project/some_class.rb", "spec/faked_project/spec/faked_spec.rb", "spec/faked_project/spec/forking_spec.rb", "spec/faked_project/spec/meta_magic_spec.rb", "spec/faked_project/spec/some_class_spec.rb", "spec/faked_project/spec/spec_helper.rb", "spec/faked_project/test/faked_test.rb", "spec/faked_project/test/meta_magic_test.rb", "spec/faked_project/test/some_class_test.rb", "spec/faked_project/test/test_helper.rb", "spec/file_list_spec.rb", "spec/filters_spec.rb", "spec/fixtures/app/controllers/sample_controller.rb", "spec/fixtures/app/models/user.rb", "spec/fixtures/deleted_source_sample.rb", "spec/fixtures/frameworks/rspec_bad.rb", "spec/fixtures/frameworks/rspec_good.rb", "spec/fixtures/frameworks/testunit_bad.rb", "spec/fixtures/frameworks/testunit_good.rb", "spec/fixtures/iso-8859.rb", "spec/fixtures/resultset1.rb", "spec/fixtures/resultset2.rb", "spec/fixtures/sample.rb", "spec/fixtures/utf-8.rb", "spec/helper.rb", "spec/merge_helpers_spec.rb", "spec/result_spec.rb", "spec/return_codes_spec.rb", "spec/source_file_line_spec.rb", "spec/source_file_spec.rb"]
  s.homepage = "http://github.com/colszowka/simplecov"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.4.5"
  s.summary = "Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.8"])
      s.add_runtime_dependency(%q<simplecov-html>, ["~> 0.10.0"])
      s.add_runtime_dependency(%q<docile>, ["~> 1.1.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.9"])
    else
      s.add_dependency(%q<json>, ["~> 1.8"])
      s.add_dependency(%q<simplecov-html>, ["~> 0.10.0"])
      s.add_dependency(%q<docile>, ["~> 1.1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.9"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.8"])
    s.add_dependency(%q<simplecov-html>, ["~> 0.10.0"])
    s.add_dependency(%q<docile>, ["~> 1.1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.9"])
  end
end

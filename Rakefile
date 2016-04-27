require "ci/reporter/rake/rspec"
Dir.glob('lib/tasks/*.rake').each { |r| load r}

task :console do
  exec "bundle exec pry -r config/environment -I ./"
end

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:rspec)
rescue LoadError
end

namespace :ci do
  task all: ["ci:setup:rspec", :rspec]
end

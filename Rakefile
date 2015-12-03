Dir.glob('lib/tasks/*.rake').each { |r| load r}

task :console do
  exec "bundle exec pry -r config/environment -I ./"
end

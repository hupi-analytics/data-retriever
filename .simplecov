# -*- encoding : utf-8 -*-
SimpleCov.start do
  load_profile "test_frameworks"
  load_profile "bundler_filter"
  add_filter 'bundle'
end

#!/bin/bash

bundle exec rake db:migrate
bundle exec rackup -p 4000

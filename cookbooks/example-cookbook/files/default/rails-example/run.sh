#!/bin/bash

source /usr/local/share/chruby/chruby.sh

cd /apps

git clone https://github.com/austenito/rails-example.git
cd rails-example
export GEM_HOME=/gems/ruby/2.1.2
mkdir pids
chruby 2.1.2
bundle install --without development test

bundle exec rake db:create db:migrate db:seed RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec unicorn_rails -c config/unicorn.rb -E production -p 3000

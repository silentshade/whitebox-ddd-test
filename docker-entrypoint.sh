#!/bin/bash
set -e

if [ $RAILS_ENV = "production" ] || [ $RAILS_ENV = "staging" ]; then
  bundle config set without 'development test'
  bundle install
else
  bundle install
  bundle exec rake db:migrate
fi

rm -f tmp/pids/server.pid

bundle exec rails s -p 3000 -b '0.0.0.0'

exec "$@"

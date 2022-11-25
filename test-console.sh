#!/bin/sh
RAILS_ENV=test bundle exec rails db:reset &&
RAILS_ENV=test bundle exec rails db:schema:load &&
RAILS_ENV=test bundle exec rake seeds:e2e &&
RAILS_ENV=test bundle exec rails console

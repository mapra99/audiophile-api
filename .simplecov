#!/usr/bin/env ruby
# https://github.com/simplecov-ruby/simplecov
# https://rubydoc.info/gems/simplecov/SimpleCov/Configuration

if ENV['COVERAGE'] == 'true'
  SimpleCov.start 'rails' do
    enable_coverage :branch
    primary_coverage :line

    minimum_coverage 83
    maximum_coverage_drop 5

    add_filter 'app/channels' # deferring until we need ActionCable
    add_filter 'app/mailer' # deferring until we need ActionMailer
    add_filter 'app/scripts'

    add_group 'Services', 'app/services'
    add_group 'Jobs', 'app/jobs'
    add_group 'Actions', 'app/actions'
  end
end

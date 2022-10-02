# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://redis:6379'),
    username: ENV.fetch('REDIS_USERNAME', nil),
    password: ENV.fetch('REDIS_PASSWORD', nil)
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://redis:6379'),
    username: ENV.fetch('REDIS_USERNAME', nil),
    password: ENV.fetch('REDIS_PASSWORD', nil)
  }
end

# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: Rails.env.production? ? ENV.fetch('REDISCLOUD_URL') : ENV.fetch('REDIS_URL', 'redis://localhost:6379')
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: Rails.env.production? ? ENV.fetch('REDISCLOUD_URL') : ENV.fetch('REDIS_URL', 'redis://localhost:6379')
  }
end

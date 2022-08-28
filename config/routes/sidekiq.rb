Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  matches_username = ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV['ADMIN_HTTP_USERNAME'])
  )

  matches_password = ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV['ADMIN_HTTP_PASSWORD'])
  )

  matches_username & matches_password
end

mount Sidekiq::Web, at: '/eng/sidekiq'

Geocoder.configure(
  # Geocoding options
  # timeout: 3,                 # geocoding service timeout (secs)
  # lookup: :nominatim,         # name of geocoding service (symbol)
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  # api_key: nil,               # API key for geocoding service
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear

  # Cache configuration
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
  ip_lookup: :ipinfo_io,
  lookup: :amazon_location_service,
  amazon_location_service: {
    index_name: 'audiophile_explore_index',
    api_key: {
      access_key_id: ENV.fetch('AWS_GEOCODE_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_GEOCODE_SECRET_ACCESS_KEY')
    }
  },
  cache: Redis.new(
    url: if Rails.env.production?
           ENV.fetch('REDISCLOUD_URL')
         else
           ENV.fetch('REDIS_URL',
                     'redis://localhost:6379')
         end
  ),
  cache_options: {
    expiration: 1.year,
    prefix: 'geocoder:'
  },
  timeout: 5 # seconds
)

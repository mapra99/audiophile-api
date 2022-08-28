VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    match_requests_on: %i[method host path body]
  }
end

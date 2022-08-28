module Locations
  class InvalidLocation < StandardError
    attr_reader :location_errors

    def initialize(location_errors)
      @location_errors = location_errors
      message = location_errors.join(', ')

      super(message)
    end
  end
end

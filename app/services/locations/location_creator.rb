module Locations
  class LocationCreator
    attr_reader :location

    def initialize(street_address:, city:, country:, postal_code:)
      self.street_address = street_address
      self.city = city
      self.country = country
      self.postal_code = postal_code
    end

    def call
      build_location
      geocode_location
      check_existing_location
      save_location
    end

    private

    attr_accessor :street_address, :city, :country, :postal_code
    attr_writer :location

    def build_location
      self.location = Location.new(
        street_address: street_address,
        city: city,
        country: country,
        postal_code: postal_code
      )
    end

    def geocode_location
      location.geocode_address
    end

    def check_existing_location
      return unless location.geocoded?

      existing_location = Location.find_by(
        longitude: location.longitude,
        latitude: location.latitude
      )

      self.location = existing_location if existing_location.present?
    end

    def save_location
      location.save!
    rescue ActiveRecord::RecordInvalid => e
      raise InvalidLocation, [e.message]
    end
  end
end

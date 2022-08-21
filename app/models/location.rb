class Location < ApplicationRecord
  has_many :user_locations, dependent: :destroy
  has_many :users, through: :user_locations

  validates :street_address, :city, :country, :postal_code, presence: true

  geocoded_by :full_address
  after_validation :geocode_address

  def full_address
    "#{street_address} #{city} #{country} #{postal_code}"
  end

  def geocode_address
    return if geocoded?

    results = Geocoder.search(full_address)
    return if results.blank?

    result = results.first

    self.longitude = result.longitude
    self.latitude = result.latitude
    self.raw_geocode = result.to_json
  end
end

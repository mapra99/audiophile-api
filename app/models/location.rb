class Location < ApplicationRecord
  has_many :user_locations, dependent: :destroy
  has_many :users, through: :user_locations

  validates :street_address, :city, :country, :postal_code, presence: true
end

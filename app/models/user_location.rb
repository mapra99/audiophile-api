class UserLocation < ApplicationRecord
  include UuidHandler

  belongs_to :user
  belongs_to :location
  has_many :orders, dependent: :nullify
end

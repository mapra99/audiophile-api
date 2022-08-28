class UserLocation < ApplicationRecord
  include UuidHandler

  belongs_to :user
  belongs_to :location
end

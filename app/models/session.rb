class Session < ApplicationRecord
  include UuidHandler

  validates :ip_address, presence: true
end

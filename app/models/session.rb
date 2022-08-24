class Session < ApplicationRecord
  include UuidHandler

  validates :ip_address, presence: true

  has_many :purchase_carts, dependent: :destroy
end

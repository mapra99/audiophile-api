class Order < ApplicationRecord
  belongs_to :payment
  belongs_to :user_location

  validates :status, presence: true

  ACTIVE = 'active'.freeze
  ON_DELIVERY = 'on_delivery'.freeze
  DELIVERED = 'delivered'.freeze

  STATUS_TYPES = [
    ACTIVE,
    ON_DELIVERY,
    DELIVERED
  ]
end

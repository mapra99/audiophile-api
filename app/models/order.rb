class Order < ApplicationRecord
  belongs_to :payment
  belongs_to :user_location
  has_one :purchase_cart, through: :payment

  validates :status, presence: true

  ACTIVE = 'active'.freeze
  ON_DELIVERY = 'on_delivery'.freeze
  DELIVERED = 'delivered'.freeze
  CANCELLED = 'cancelled'.freeze

  STATUS_TYPES = [
    ACTIVE,
    ON_DELIVERY,
    DELIVERED,
    CANCELLED
  ].freeze
end

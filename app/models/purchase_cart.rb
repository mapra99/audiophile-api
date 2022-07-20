class PurchaseCart < ApplicationRecord
  include UuidHandler

  STARTED = 'started'.freeze
  PAID = 'paid'.freeze
  CANCELED = 'canceled'.freeze

  STATUS_TYPES = [
    STARTED,
    PAID,
    CANCELED
  ].freeze

  validates :total_price, presence: true
  validates :status, presence: true, inclusion: { in: STATUS_TYPES }

  has_many :purchase_cart_items, dependent: :destroy
  has_many :purchase_cart_extra_fees, dependent: :destroy
end

class PurchaseCartExtraFee < ApplicationRecord
  SHIPPING_FEE = 'shipping'.freeze

  KEYS = [
    SHIPPING_FEE
  ].freeze

  belongs_to :purchase_cart

  validates :key, presence: true, uniqueness: { scope: :purchase_cart_id }, inclusion: { in: KEYS }
  validates :price, presence: true
end

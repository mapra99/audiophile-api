class PurchaseCartItem < ApplicationRecord
  belongs_to :stock
  belongs_to :purchase_cart

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :stock_id, uniqueness: { scope: :purchase_cart_id }
end

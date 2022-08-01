class PurchaseCartItem < ApplicationRecord
  include UuidHandler

  belongs_to :stock
  belongs_to :purchase_cart

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :stock_id, uniqueness: { scope: :purchase_cart_id }

  def total_price
    (unit_price * quantity).to_f
  end
end

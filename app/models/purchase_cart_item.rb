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

  def reduce_stock_amount!
    new_amount = stock.quantity - quantity
    stock.update!(quantity: new_amount)
  end
end

class Stock < ApplicationRecord
  include UuidHandler

  belongs_to :product
  has_many :stock_toppings, dependent: :destroy
  has_many :toppings, through: :stock_toppings

  validates :quantity, presence: true

  def self.filter_exactly_by_toppings(toppings)
    includes(:toppings).select do |stock|
      stock.toppings.pluck(:id).sort == toppings.pluck(:id).sort
    end
  end

  def price
    base_price = product.base_price
    price_changes = toppings.pluck(:price_change).compact

    calc_expr = "#{base_price}.to_f"
    calc_expr += price_changes.reduce(:+) || ''

    # rubocop:disable Security/Eval
    eval(calc_expr)
    # rubocop:enable Security/Eval
  end
end

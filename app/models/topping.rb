class Topping < ApplicationRecord
  PRICE_CHANGE_REGEXP = /\A(\+|-)(\d+\.?\d*)\z/

  belongs_to :product
  has_many :stock_toppings, dependent: :destroy
  has_many :stocks, through: :stock_toppings

  validates :key, presence: true, uniqueness: { scope: %i[value product_id] }
  validates :value, presence: true
  validates :price_change,
            format: { with: PRICE_CHANGE_REGEXP, message: 'must follow the price change format (e.g. +120.2)' }
end

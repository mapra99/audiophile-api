class Topping < ApplicationRecord
  PRICE_CHANGE_REGEXP = /\A(\+|-)(\d+\.?\d*)\z/

  belongs_to :product
  has_many :stock_toppings, dependent: :destroy
  has_many :stocks, through: :stock_toppings

  validates :key, presence: true, uniqueness: { scope: %i[value product_id] }
  validates :value, presence: true
  validates :price_change,
            format: { with: PRICE_CHANGE_REGEXP, message: 'must follow the price change format (e.g. +120.2)' }

  def self.grouped_by_key
    keys = pluck(:key).uniq
    result = {}
    keys.each do |key|
      result[key.to_sym] = where(key: key)
    end

    result
  end
end

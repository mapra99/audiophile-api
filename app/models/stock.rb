class Stock < ApplicationRecord
  belongs_to :product
  has_many :stock_toppings, dependent: :destroy
  has_many :toppings, through: :stock_toppings

  validates :quantity, presence: true
end

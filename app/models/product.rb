class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_one_attached :image
  has_many :product_contents, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :toppings, dependent: :destroy
  belongs_to :product_category

  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true

  def total_quantity
    stocks.pluck(:quantity).sum
  end
end

class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_one_attached :image
  has_many :product_contents, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :toppings, dependent: :destroy
  has_many :product_recommendations, dependent: :destroy
  has_many :recommended_products, through: :product_recommendations, source: :recommendation
  has_many :product_page_views, dependent: :nullify
  has_many :page_views, through: :product_page_views
  belongs_to :product_category

  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true

  scope :with_available_stocks, -> { where(id: Stock.available.pluck(:product_id)) }

  def total_quantity
    stocks.pluck(:quantity).sum
  end
end

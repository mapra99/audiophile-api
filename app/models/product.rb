class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_one_attached :image
  has_many :product_contents, dependent: :destroy
  belongs_to :product_category

  validates :name, presence: true, uniqueness: true
  validates :base_price, presence: true
end

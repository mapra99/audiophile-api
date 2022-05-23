class ProductCategory < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :products, dependent: :restrict_with_exception
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
end

class ProductContent < ApplicationRecord
  has_many_attached :files
  belongs_to :product

  validates :key, presence: true, uniqueness: { scope: :product_id }
  validates_with Validators::ContentValueValidator
end

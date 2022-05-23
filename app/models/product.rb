class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :category, class_name: 'ProductCategory', foreign_key: 'product_category_id'
end

class ProductRecommendation < ApplicationRecord
  belongs_to :product
  belongs_to :recommendation, class_name: 'Product'
end

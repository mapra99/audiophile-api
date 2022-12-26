class ProductPageView < ApplicationRecord
  belongs_to :product
  belongs_to :page_view
end

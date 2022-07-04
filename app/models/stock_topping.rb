class StockTopping < ApplicationRecord
  belongs_to :stock
  belongs_to :topping
end

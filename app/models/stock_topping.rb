class StockTopping < ApplicationRecord
  belongs_to :stock
  belongs_to :topping

  validates_with Validators::StockToppingsValidator
end

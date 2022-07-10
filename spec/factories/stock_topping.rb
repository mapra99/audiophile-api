FactoryBot.define do
  factory :stock_topping do
    association :stock
    association :topping
  end
end

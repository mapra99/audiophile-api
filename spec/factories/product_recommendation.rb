FactoryBot.define do
  factory :product_recommendation do
    association :product
    association :recommendation, factory: :product
  end
end

FactoryBot.define do
  factory :stock do
    association :product
    quantity { rand(0..100) }
  end
end

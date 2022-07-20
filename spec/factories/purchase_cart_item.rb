FactoryBot.define do
  factory :purchase_cart_item do
    association :purchase_cart
    association :stock
    quantity { rand(1..5) }
    unit_price { rand(0..5000) }
  end
end

FactoryBot.define do
  factory :purchase_cart_extra_fee do
    association :purchase_cart
    key { PurchaseCartExtraFee::KEYS }
    price { rand(0..5000) }
  end
end

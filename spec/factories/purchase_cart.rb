FactoryBot.define do
  factory :purchase_cart do
    association :session

    total_price { rand(0..5000) }
    status { PurchaseCart::STATUS_TYPES.sample }
  end
end

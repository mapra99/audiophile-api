FactoryBot.define do
  factory :topping do
    association :product
    key { %w[color size length].sample }
    value { Faker::Lorem.paragraph }
    price_change { %w[+120.0 +0.21 -1200 -56.0].sample }
  end
end

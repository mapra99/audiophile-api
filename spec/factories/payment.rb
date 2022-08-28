FactoryBot.define do
  factory :payment do
    association :user
    association :purchase_cart

    status { Payment::STATUS_TYPES.sample }
    amount { rand(1..10_000) }
    provider_id { SecureRandom.hex }
  end
end

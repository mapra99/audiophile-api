FactoryBot.define do
  factory :order do
    association :payment
    association :user_location

    status { Order::STATUS_TYPES.sample }
  end
end

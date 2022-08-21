FactoryBot.define do
  factory :user_location do
    association :location
    association :user
  end
end

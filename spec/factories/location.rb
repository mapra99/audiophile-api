FactoryBot.define do
  factory :location do
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    postal_code { Faker::Address.postcode }
  end
end

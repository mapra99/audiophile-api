FactoryBot.define do
  factory :location do
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    postal_code { Faker::Address.postcode }

    factory :colpatria_tower_co do
      street_address { 'Cra 7 # 24-89' }
      city { 'Bogota' }
      country { 'Colombia' }
      postal_code { 110_010 }
    end
  end
end

FactoryBot.define do
  factory :session do
    ip_address { Faker::Internet.ip_v4_address }
  end
end

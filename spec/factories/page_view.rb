FactoryBot.define do
  factory :page_view do
    association :session

    page_path { Faker::Internet.url }
    query_params { Faker::Internet.slug }
  end
end

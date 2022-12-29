FactoryBot.define do
  factory :product_page_view do
    association :product
    association :page_view
  end
end

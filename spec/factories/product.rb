FactoryBot.define do
  factory :product do
    association :product_category
    name { Faker::Commerce.product_name }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/product_image.png', 'image/png') }
    base_price { Faker::Commerce.price(range: 100..5000.0) }

    factory :featured_product do
      featured { true }
    end
  end
end

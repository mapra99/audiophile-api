FactoryBot.define do
  factory :product_category do
    name { Faker::Commerce.product_name }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/product_image.png', 'image/png') }
  end
end

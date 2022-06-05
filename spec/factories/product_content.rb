FactoryBot.define do
  factory :product_content do
    association :product
    key { %w[features includes].sample }

    factory :text_product_content do
      value { Faker::Lorem.paragraph }
    end

    factory :attachment_product_content do
      files { [Rack::Test::UploadedFile.new('spec/fixtures/files/product_image.png', 'image/png')] }
    end
  end
end

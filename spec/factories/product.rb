FactoryBot.define do
  factory :product do
    association :product_category
    name { Faker::Commerce.product_name }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/product_image.png', 'image/png') }
    base_price { Faker::Commerce.price(range: 100..5000.0) }

    factory :featured_product do
      featured { true }

      after :create do |product|
        create(:text_product_content, product: product, key: 'featured_description')
        create(:text_product_content, product: product, key: 'description')
        create(:text_product_content, product: product, key: 'features')
        create(
          :product_content,
          product: product,
          key: 'box_content',
          value: '[{"quantity": "1x", "content": "Headphone Unit"},{"quantity": "2x", "content": "Replacement Earcups"}]'
        )
        create(:attachment_product_content, product: product, key: 'preview_images')
        create(:attachment_product_content, product: product, key: 'featured_image')
      end
    end
  end
end

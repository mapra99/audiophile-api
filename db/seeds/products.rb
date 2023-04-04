# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module Seeds
  class Products
    class << self
      def seed!
        ### ZX7 SPEAKER START
        product_creator = Admin::V1::Products::Creator.new(
          params: {
            name: 'ZX7 Speaker',
            price: 3500,
            category_id: ProductCategory.find_by(name: 'Speakers')&.id,
            featured: false,
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/zx7.webp', 'image/webp'
            )
          }
        )

        product_creator.call
        product = product_creator.product

        # create stock units
        Admin::V1::Stocks::Creator.new(
          params: {
            product_id: product.id,
            quantity: 10,
            toppings: []
          }
        ).call

        # create product cms content
        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'preview_images',
            content: [
              Rack::Test::UploadedFile.new('db/seeds/assets/zx7-prev1.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/zx7-prev2.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/zx7-prev3.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'box_content',
            content: "[{\"quantity\": \"2x\", \"content\": \"Speaker Unit\"}, {\"quantity\": \"2x\", \
                      \"content\": \"Speaker Cloth Panel\"}, {\"quantity\": \"1x\", \"content\": \"User Manual\"}, \
                      {\"quantity\": \"1x\", \"content\": \"3.5mm 7.5m Audio Cable\"}, {\"quantity\": \"1x\", \
                      \"content\": \"7.5m Optical Cable\"}]"
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'features',
            content: "Reap the advantages of a flat diaphragm tweeter cone. This provides a fast response rate and \
                      excellent high frequencies that lower tiered bookshelf speakers cannot provide. The woofers are \
                      made from aluminum that produces a unique and clear sound. XLR inputs allow you to connect to a \
                      mixer for more advanced usage.\n\nThe ZX7 speaker is the perfect blend of stylish design and \
                      high performance. It houses an encased MDF wooden enclosure which minimises acoustic resonance. \
                      Dual connectivity allows pairing through bluetooth or traditional optical and RCA input. Switch \
                      input sources and control volume at your finger tips with the included wireless remote. This \
                      versatile speaker is equipped to deliver an authentic listening experience."
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'description',
            content: "Stream high quality sound wirelessly with minimal to no loss. The ZX7 speaker uses high-end \
                      audiophile components that represents the top of the line powered speakers for home or \
                      studio use."
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_featured',
            content: 'true'
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_image',
            content: [
              Rack::Test::UploadedFile.new('db/seeds/assets/zx7-home.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_banner',
            content: 'integrated_background'
          }
        ).call
        ### ZX7 SPEAKER END
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize

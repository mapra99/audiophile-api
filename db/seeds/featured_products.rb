# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
module Seeds
  class FeaturedProducts
    class << self
      def seed!
        ### MARK II HEADPHONES START
        product_creator = Admin::V1::Products::Creator.new(
          params: {
            name: 'XX99 Mark II Headphones',
            price: 4500,
            category_id: ProductCategory.find_by(name: 'Headphones')&.id,
            featured: true,
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/xx99-mark-ii.webp', 'image/webp'
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
              Rack::Test::UploadedFile.new('db/seeds/assets/xx99-mark-ii-prev1.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/xx99-mark-ii-prev2.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/xx99-mark-ii-prev3.webp', 'image/webp')
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
            content: "As the headphones all others are measured against, the XX99 Mark II demonstrates over five \
                      decades of audio expertise, redefining the critical listening experience. This pair of \
                      closed-back headphones are made of industrial, aerospace-grade materials to emphasize \
                      durability at a relatively light weight of 11 oz.\n\nFrom the handcrafted microfiber ear \
                      cushions to the robust metal headband with inner damping element, the components work \
                      together to deliver comfort and uncompromising sound. Its closed-back design delivers up to \
                      27 dB of passive noise cancellation, reducing resonance by reflecting sound to a dedicated \
                      absorber. For connectivity, a specially tuned cable is included with a balanced gold connector."
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'description',
            content: 'As the gold standard for headphones, the classic XX99 Mark II offers detailed and accurate \
                      audio reproduction for audiophiles, mixing engineers, and music aficionados alike in studios \
                      and on the go.'
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'featured_image',
            content: [
              Rack::Test::UploadedFile.new('db/seeds/assets/xx99-mark-ii-featured.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'featured_description',
            content: "Experience natural, lifelike audio and exceptional build quality made for the passionate \
                      music enthusiast."
          }
        ).call
        ### MARK II HEADPHONES END

        ### ZX9 SPEAKER START
        product_creator = Admin::V1::Products::Creator.new(
          params: {
            name: 'ZX9 Speaker',
            price: 4500,
            category_id: ProductCategory.find_by(name: 'Speakers')&.id,
            featured: true,
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/zx9.webp', 'image/webp'
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
              Rack::Test::UploadedFile.new('db/seeds/assets/zx9-prev1.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/zx9-prev2.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/zx9-prev3.webp', 'image/webp')
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
            content: "Connect via Bluetooth or nearly any wired source. This speaker features optical, digital \
                      coaxial, USB Type-B, stereo RCA, and stereo XLR inputs, allowing you to have up to five \
                      wired source devices connected for easy switching. Improved bluetooth technology offers \
                      near lossless audio quality at up to 328ft (100m).\n\nDiscover clear, more natural \
                      sounding highs than the competition with ZX9's signature planar diaphragm tweeter. Equally \
                      important is its powerful room-shaking bass courtesy of a 6.5” aluminum alloy bass unit. \
                      You’ll be able to enjoy equal sound quality whether in a large room or small den. Furthermore, \
                      you will experience new sensations from old songs since it can respond to even the \
                      subtle waveforms."
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'description',
            content: "Upgrade your sound system with the all new ZX9 active speaker. It's a bookshelf speaker system \
                      that offers truly wireless connectivity -- creating new possibilities for more pleasing and \
                      practical audio setups."
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
              Rack::Test::UploadedFile.new('db/seeds/assets/zx9-home.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_banner',
            content: 'primary'
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_description',
            content: 'Upgrade to premium speakers that are phenomenally built to deliver truly remarkable sound.'
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'featured_image',
            content: [
              Rack::Test::UploadedFile.new('db/seeds/assets/zx9-featured.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'featured_description',
            content: 'Upgrade to premium speakers that are phenomenally built to deliver truly remarkable sound.'
          }
        ).call
        ### ZX9 SPEAKER END

        ### YX1 EARPHONES START
        product_creator = Admin::V1::Products::Creator.new(
          params: {
            name: 'YX1 Wireless Earphones',
            price: 599,
            category_id: ProductCategory.find_by(name: 'Earphones')&.id,
            featured: true,
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/yx1.webp', 'image/webp'
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
              Rack::Test::UploadedFile.new('db/seeds/assets/yx1-prev1.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/yx1-prev2.webp', 'image/webp'),
              Rack::Test::UploadedFile.new('db/seeds/assets/yx1-prev3.webp', 'image/webp')
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
            content: "Experience unrivalled stereo sound thanks to innovative acoustic technology. With improved \
                      ergonomics designed for full day wearing, these revolutionary earphones have been finely \
                      crafted to provide you with the perfect fit, delivering complete comfort all day long \
                      while enjoying exceptional noise isolation and truly immersive sound.\n\nThe YX1 Wireless \
                      Earphones features customizable controls for volume, music, calls, and voice assistants \
                      built into both earbuds. The new 7-hour battery life can be extended up to 28 hours with \
                      the charging case, giving you uninterrupted play time. Exquisite craftsmanship with a \
                      splash resistant design now available in an all new white and grey color scheme as well as \
                      the popular classic black."
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'description',
            content: "Tailor your listening experience with bespoke dynamic drivers from the new YX1 Wireless \
                      Earphones. Enjoy incredible high-fidelity sound even in noisy environments with its \
                      active noise cancellation feature."
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
              Rack::Test::UploadedFile.new('db/seeds/assets/yx1-home.webp', 'image/webp')
            ]
          }
        ).call

        Admin::V1::ProductContents::Creator.new(
          params: {
            product_id: product.id,
            key: 'home_banner',
            content: 'side_by_side'
          }
        ).call
        ### YX1 EARPHONES END
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ClassLength

# rubocop:disable Metrics/MethodLength
module Seeds
  class ProductCategories
    class << self
      def seed!
        Admin::V1::ProductCategories::Creator.new(
          params: {
            name: 'Headphones',
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/headphones_category.png', 'image/png'
            )
          }
        ).call

        Admin::V1::ProductCategories::Creator.new(
          params: {
            name: 'Speakers',
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/speakers_category.png', 'image/png'
            )
          }
        ).call

        Admin::V1::ProductCategories::Creator.new(
          params: {
            name: 'Earphones',
            image: Rack::Test::UploadedFile.new(
              'db/seeds/assets/earphones_category.png', 'image/png'
            )
          }
        ).call
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength

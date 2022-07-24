module Api
  module V1
    module ProductCategories
      class Finder
        include Dry::Monads[:result]

        attr_reader :product_category

        def initialize(slug:)
          self.slug = slug
        end

        def call
          result = ProductCategory.find_by!(slug: slug)

          self.product_category = result
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          Failure({ code: :not_found })
        end

        private

        attr_accessor :slug
        attr_writer :product_category
      end
    end
  end
end

module Api
  module V1
    module Products
      class Finder
        include Dry::Monads[:result]

        attr_reader :product

        def initialize(slug:)
          self.slug = slug
        end

        def call
          result = Product.find_by!(slug: slug)

          self.product = result
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          Failure({ code: :not_found })
        end

        private

        attr_accessor :slug
        attr_writer :product
      end
    end
  end
end

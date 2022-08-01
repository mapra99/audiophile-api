module Admin
  module V1
    module Products
      class Finder
        include Dry::Monads[:result]

        attr_reader :product

        def initialize(product_id:)
          self.product_id = product_id
        end

        def call
          result = Product.find(product_id)

          self.product = result
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          Failure({ code: :not_found })
        end

        private

        attr_accessor :product_id
        attr_writer :product
      end
    end
  end
end

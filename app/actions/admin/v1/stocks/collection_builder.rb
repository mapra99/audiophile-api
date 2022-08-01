module Admin
  module V1
    module Stocks
      class CollectionBuilder
        include Dry::Monads[:result]

        def call(filters: {})
          self.result = Stock.all
          filter_by_product(filters[:product_id]) if filters[:product_id].present?

          Success(result)
        rescue StandardError => e
          Rails.logger.error(e)

          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result

        def filter_by_product(product_id)
          self.result = result.where(product_id: product_id)
        end
      end
    end
  end
end

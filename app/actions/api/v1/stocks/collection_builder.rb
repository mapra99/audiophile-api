module Api
  module V1
    module Stocks
      class CollectionBuilder
        include Dry::Monads[:result]

        def call(product_slug:, toppings_filters: {})
          self.product_slug = product_slug

          find_product
          filter_by_product
          filter_by_toppings(toppings_filters.to_h) if toppings_filters.present?

          Success(result)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result, :product_slug, :product

        def find_product
          self.product = Product.find_by(slug: product_slug)
          raise ServiceError, Failure({ code: :product_not_found }) if product.blank?
        end

        def find_topping(key, value)
          topping = product.toppings.find_by(key: key, value: value)
          return topping if topping.present?

          raise ServiceError, Failure(
            { code: :topping_not_found, message: ["Could not find topping with key #{key} and value #{value}"] }
          )
        end

        def filter_by_product
          self.result = product.stocks
        end

        def filter_by_toppings(toppings_filters)
          toppings = toppings_filters.map do |key, value|
            find_topping(key, value)
          end

          self.result = result.filter_exactly_by_toppings(toppings)
        end
      end
    end
  end
end

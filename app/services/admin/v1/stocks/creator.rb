module Admin
  module V1
    module Stocks
      class Creator
        include Dry::Monads[:result]

        attr_reader :params, :stock

        def initialize(params:)
          self.params = params
        end

        def call
          ActiveRecord::Base.transaction do
            find_product
            build_stock
            save_stock
            save_toppings
          end

          Success(stock)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :params, :stock
        attr_accessor :product

        def find_product
          self.product = Product.find(params[:product_id])
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_not_found })
        end

        def build_stock
          self.stock = Stock.new(
            product: product,
            quantity: params[:quantity]
          )
        end

        def save_stock
          stock.save!
        rescue ActiveRecord::RecordNotSaved => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :stock_not_saved })
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_stock, message: stock.errors.full_messages })
        end

        def save_toppings
          params[:toppings].each { |topping_params| save_topping(topping_params) }
        end

        def save_topping(topping_params)
          topping = product.toppings.find_or_initialize_by(
            key: topping_params[:key],
            value: topping_params[:value]
          )

          topping.price_change = topping_params[:price_change]
          topping.save!
          stock.toppings << topping
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_toppings, message: [e.message] })
        end
      end
    end
  end
end

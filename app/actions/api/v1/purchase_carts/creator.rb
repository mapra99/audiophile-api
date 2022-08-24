module Api
  module V1
    module PurchaseCarts
      class Creator
        include Dry::Monads[:result]

        attr_reader :params, :purchase_cart

        def initialize(params:, session:)
          self.params = params
          self.session = session
        end

        def call
          ActiveRecord::Base.transaction do
            create_cart
            assign_items
            assign_extra_fees
          end

          Success(purchase_cart)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :params, :purchase_cart
        attr_accessor :session

        def create_cart
          self.purchase_cart = session.purchase_carts.create(
            status: PurchaseCart::STARTED,
            total_price: 0
          )
        end

        def assign_items
          params[:items].each do |item_params|
            build_item(item_params)
          end
        end

        def build_item(item_params)
          Purchases::CartItemGenerator.new(
            cart: purchase_cart,
            stock_uuid: item_params[:stock_uuid],
            quantity: item_params[:quantity]
          ).call
        rescue Purchases::StockNotFound => e
          raise ServiceError, Failure({ code: :stock_not_found, message: e.message })
        rescue Purchases::InsufficientStock => e
          raise ServiceError, Failure({ code: :insufficient_stock, message: e.message })
        rescue Purchases::InvalidCartItem => e
          raise ServiceError, Failure({ code: :invalid_cart_item, message: e.message })
        end

        def assign_extra_fees
          Purchases::ExtraFeesGenerator.new(cart: purchase_cart).call
        rescue Purchases::InvalidExtraFee => e
          raise ServiceError, Failure({ code: :invalid_extra_fee, message: e.message })
        end
      end
    end
  end
end

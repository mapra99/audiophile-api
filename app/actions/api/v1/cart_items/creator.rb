module Api
  module V1
    module CartItems
      class Creator
        include Dry::Monads[:result]

        attr_reader :cart_item

        def initialize(cart_uuid:, item_params:, session:)
          self.item_params = item_params
          self.cart_uuid = cart_uuid
          self.session = session
        end

        def call
          set_cart_item_generator
          create_item

          Success(cart_item)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :cart_item
        attr_accessor :cart_uuid, :item_params, :cart_item_generator, :session

        def set_cart_item_generator
          self.cart_item_generator = Purchases::CartItemGenerator.new(
            cart_uuid: cart_uuid,
            stock_uuid: item_params[:stock_uuid],
            quantity: item_params[:quantity],
            session: session
          )
        end

        # rubocop:disable Metrics/AbcSize
        def create_item
          cart_item_generator.call
          self.cart_item = cart_item_generator.cart_item
        rescue Purchases::CartNotFound => e
          raise ServiceError, Failure({ code: :cart_not_found, message: e.message })
        rescue Purchases::StockNotFound => e
          raise ServiceError, Failure({ code: :stock_not_found, message: e.message })
        rescue Purchases::InsufficientStock => e
          raise ServiceError, Failure({ code: :insufficient_stock, message: e.message })
        rescue Purchases::InvalidCartItem => e
          raise ServiceError, Failure({ code: :invalid_cart_item, message: e.message })
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end

module Api
  module V1
    module PurchaseCarts
      class Destroyer
        include Dry::Monads[:result]

        def initialize(cart_uuid:)
          self.cart_uuid = cart_uuid
        end

        def call
          cancel_cart
          Success()
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :cart_uuid

        def cancel_cart
          Purchases::CartCanceler.new(cart_uuid: cart_uuid).call
        rescue Purchases::CartNotFound => e
          raise ServiceError, Failure({ code: :cart_not_found, message: e.message })
        rescue Purchases::InvalidStatusForCancelation => e
          raise ServiceError, Failure({ code: :invalid_status, message: e.message })
        end
      end
    end
  end
end

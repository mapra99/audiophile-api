module Api
  module V1
    module Payments
      class Creator
        include Dry::Monads[:result]

        attr_reader :payment, :payment_intent

        def initialize(purchase_cart_uuid:, user:)
          self.purchase_cart_uuid = purchase_cart_uuid
          self.user = user
        end

        def call
          find_purchase_cart
          start_payment

          Success(nil)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :purchase_cart_uuid, :purchase_cart, :user
        attr_writer :payment_intent, :payment

        def find_purchase_cart
          self.purchase_cart = PurchaseCart.find_by(uuid: purchase_cart_uuid)
          if purchase_cart.blank?
            raise ServiceError,
                  Failure({ code: :purchase_cart_not_found,
                            message: 'Purchase cart not found' })
          end
          return if purchase_cart.status == PurchaseCart::STARTED

          raise ServiceError,
                Failure({ code: :invalid_purchase_cart,
                          message: 'Purchase cart has invalid status' })
        end

        def start_payment
          payment_starter = ::Payments::StartPayment.new(purchase_cart: purchase_cart, user: user)
          payment_starter.call

          self.payment = payment_starter.payment
          self.payment_intent = payment_starter.payment_intent
        rescue ::Payments::InvalidPayment => e
          raise ServiceError, Failure({ code: :invalid_payment, message: e.message})
        rescue ::Payments::ProviderError => e
          raise ServiceError, Failure({ code: :provider_error, message: e.message})
        end
      end
    end
  end
end

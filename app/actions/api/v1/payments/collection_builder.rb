module Api
  module V1
    module Payments
      class CollectionBuilder
        include Dry::Monads[:result]

        attr_reader :payments

        def initialize(user:, purchase_cart_uuid:)
          self.user = user
          self.purchase_cart_uuid = purchase_cart_uuid
        end

        def call
          fetch_payments
          filter_by_purchase_cart if purchase_cart_uuid.present?

          Success(payments)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :user, :purchase_cart_uuid
        attr_writer :payments

        def fetch_payments
          self.payments = user.payments
        end

        def filter_by_purchase_cart
          purchase_cart = find_purchase_cart
          self.payments = payments.where(purchase_cart: purchase_cart)
        end

        def find_purchase_cart
          purchase_cart = PurchaseCart.find_by(uuid: purchase_cart_uuid)

          return purchase_cart if purchase_cart.present?

          raise ServiceError,
                Failure({ code: :purchase_cart_not_found, message: "Purchase cart #{purchase_cart_uuid} not found" })
        end
      end
    end
  end
end

module Api
  module V1
    module PurchaseCarts
      class Finder
        include Dry::Monads[:result]

        attr_reader :cart

        def initialize(cart_uuid:, session:)
          self.cart_uuid = cart_uuid
          self.session = session
        end

        def call
          result = session.purchase_carts.find_by!(uuid: cart_uuid)

          self.cart = result
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          Failure({ code: :cart_not_found, message: "Cart with uuid #{cart_uuid} not found" })
        end

        private

        attr_accessor :cart_uuid, :session
        attr_writer :cart
      end
    end
  end
end

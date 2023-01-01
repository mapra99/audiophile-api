module Api
  module V1
    module PurchaseCarts
      class Updater
        include Dry::Monads[:result]

        attr_reader :params, :purchase_cart

        def initialize(params:, owner:)
          self.params = params
          self.owner = owner
        end

        def call
          ActiveRecord::Base.transaction do
            find_cart
            update_user_location
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
        attr_accessor :owner

        def find_cart
          self.purchase_cart = owner.purchase_carts.find_by!(uuid: params[:uuid])
        rescue ActiveRecord::RecordNotFound => e
          raise ServiceError, Failure({ code: :cart_not_found, message: e.message })
        end

        def update_user_location
          user_location = UserLocation.find_by!(uuid: params[:user_location_uuid])
          purchase_cart.update!(user_location: user_location)
        end
      end
    end
  end
end

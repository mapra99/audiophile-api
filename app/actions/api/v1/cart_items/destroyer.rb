module Api
  module V1
    module CartItems
      class Destroyer
        include Dry::Monads[:result]

        def initialize(item_uuid:)
          self.item_uuid = item_uuid
        end

        def call
          remove_item
          Success()
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :item_uuid

        def remove_item
          Purchases::CartItemRemover.new(item_uuid: item_uuid).call
        rescue Purchases::CartItemNotFound => e
          raise ServiceError, Failure({ code: :cart_item_not_found, message: e.message })
        end
      end
    end
  end
end

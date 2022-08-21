module Api
  module V1
    module PurchaseCarts
      class CollectionBuilder
        include Dry::Monads[:result]

        def initialize(session:)
          self.session = session
        end

        def call
          self.result = session.purchase_carts

          Success(result)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result, :session
      end
    end
  end
end

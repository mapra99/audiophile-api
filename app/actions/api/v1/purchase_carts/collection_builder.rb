module Api
  module V1
    module PurchaseCarts
      class CollectionBuilder
        include Dry::Monads[:result]

        def initialize(owner:, filters: {})
          self.owner = owner
          self.filters = filters
        end

        def call
          self.result = owner.purchase_carts
          self.result = filter_by_status

          Success(result)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result, :owner, :filters

        def filter_by_status
          return result if filters[:status].blank?

          result.where(status: filters[:status])
        end
      end
    end
  end
end

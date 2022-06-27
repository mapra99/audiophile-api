module Api
  module V1
    module ProductCategories
      class CollectionBuilder
        include Dry::Monads[:result]

        def call
          self.result = ProductCategory.all

          Success(result)
        rescue StandardError => e
          Rails.logger.error(e)

          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result
      end
    end
  end
end

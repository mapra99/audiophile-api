module Admin
  module V1
    module ProductCategories
      class CollectionBuilder
        include Dry::Monads[:result]

        def call(filters: {})
          self.result = ProductCategory.all
          filter_by_name(filters[:name]) if filters[:name].present?

          Success(result)
        rescue StandardError => e
          Rails.logger.error(e)

          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result

        def filter_by_name(name)
          self.result = result.where('name LIKE ?', "%#{name}%")
        end
      end
    end
  end
end

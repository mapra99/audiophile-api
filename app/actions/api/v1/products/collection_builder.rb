module Api
  module V1
    module Products
      class CollectionBuilder
        include Dry::Monads[:result]

        def call(filters: {})
          self.result = Product.all
          apply_filters(filters)

          Success(result)
        rescue StandardError => e
          Rails.logger.error(e)

          Failure({ code: :internal_error })
        end

        private

        attr_accessor :result

        def apply_filters(filters)
          filter_by_category(filters[:category_ids]) if filters[:category_ids].present?
          filter_by_featured(filters[:featured]) if filters[:featured].present?
          filter_by_content(filters[:content]) if filters[:content].present?
        end

        def filter_by_category(category_ids)
          category_ids_arr = category_ids.split(',')
          self.result = result.where(product_category_id: category_ids_arr)
        end

        def filter_by_featured(featured)
          self.result = result.where(featured: featured)
        end

        def filter_by_content(content_filters)
          product_contents = ProductContent.all

          content_filters.to_h.each do |key, value|
            product_contents = product_contents.where('key = ? AND value = ?', key, value)
          end

          self.result = result.where(id: product_contents.pluck(:product_id))
        end
      end
    end
  end
end

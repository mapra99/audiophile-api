module Api
  module V1
    class ProductCategoriesController < BaseController
      def index
        collection_builder = Api::V1::ProductCategories::CollectionBuilder.new
        result = collection_builder.call
        return render_error_from(result) if result.failure?

        @product_categories = result.value!
      end
    end
  end
end

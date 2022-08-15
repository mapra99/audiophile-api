module Api
  module V1
    class ProductCategoriesController < BaseController
      skip_before_action :authenticate_user_by_token!

      def index
        collection_builder = Api::V1::ProductCategories::CollectionBuilder.new
        result = collection_builder.call
        return render_error_from(result) if result.failure?

        @product_categories = result.value!
      end

      def show
        finder = Api::V1::ProductCategories::Finder.new(slug: params[:slug])
        result = finder.call
        return render_error_from(result) if result.failure?

        @product_category = result.value!
      end
    end
  end
end

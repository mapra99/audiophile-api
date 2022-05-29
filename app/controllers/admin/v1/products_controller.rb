module Admin
  module V1
    class ProductsController < BaseController
      def index
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @products = result.value!
      end

      private

      def filter_params
        params.permit(:featured, :categories)
      end

      def collection_builder
        @collection_builder ||= Admin::V1::Products::CollectionBuilder.new
      end
    end
  end
end

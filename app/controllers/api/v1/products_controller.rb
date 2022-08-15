module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :authenticate_user_by_token!

      def index
        collection_builder = Api::V1::Products::CollectionBuilder.new
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @products = result.value!
      end

      def show
        finder = Api::V1::Products::Finder.new(slug: params[:slug])
        result = finder.call
        return render_error_from(result) if result.failure?

        @product = result.value!
      end

      private

      def filter_params
        params.permit(:featured, :categories)
      end
    end
  end
end

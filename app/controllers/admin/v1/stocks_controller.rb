module Admin
  module V1
    class StocksController < BaseController
      def index
        collection_builder = Admin::V1::Stocks::CollectionBuilder.new
        result = collection_builder.call(filters: filter_params)
        return render_error_from(result) if result.failure?

        @stocks = result.value!
      end

      private

      def filter_params
        params.permit(:product_id)
      end
    end
  end
end
